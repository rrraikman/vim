vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd.source("~/.vimrc")

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  { src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("4") },
  "https://github.com/neovim/nvim-lspconfig",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/Mofiqul/vscode.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
  "https://github.com/b0o/SchemaStore.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",
})

require("vscode").setup({})
vim.cmd.colorscheme("vscode")

require("lualine").setup({
  options = { theme = "vscode", globalstatus = true },
  extensions = { "neo-tree", "fzf" },
})

require("nvim-treesitter").install({ "typescript", "tsx", "javascript", "json" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json" },
  callback = function()
    -- pcall: the parser install above is async, so it may not be there on first launch
    pcall(vim.treesitter.start)
  end,
})

require("neo-tree").setup({
  close_if_last_window = true,
  window = {
    mappings = {
      ["<esc>"] = function()
        vim.cmd("silent! wincmd p")
      end,
    },
  },
  filesystem = {
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = "open_default",
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_by_name = { ".git", "node_modules" },
    },
  },
})

-- :bdelete closes every window showing the buffer, and once only neo-tree's window
-- is left, close_if_last_window quits nvim. Swap each window to another buffer
-- first so the editor window survives.
local function close_buffer(bufnr)
  if bufnr == nil or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  -- A terminal is never "modified", but bdelete refuses to kill its running shell
  -- without !; closing its tab should end the shell like VS Code's trash icon.
  local is_terminal = vim.bo[bufnr].buftype == "terminal"
  if not is_terminal and vim.bo[bufnr].modified then
    vim.notify(vim.fn.bufname(bufnr) .. " has unsaved changes", vim.log.levels.WARN)
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
      vim.cmd("silent! bprevious")
      if vim.api.nvim_get_current_buf() == bufnr then
        vim.cmd.enew()
      end
    end)
  end
  vim.cmd.bdelete({ args = { tostring(bufnr) }, bang = is_terminal })
end

require("bufferline").setup({
  options = {
    close_command = close_buffer,
    right_mouse_command = close_buffer,
    offsets = { { filetype = "neo-tree", text = "Explorer", separator = true } },
  },
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = { documentation = { auto_show = true } },
  signature = { enabled = true },
})

vim.lsp.config("jsonls", {
  settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
    },
  },
})
vim.lsp.enable({ "ts_ls", "bashls", "yamlls", "jsonls", "lua_ls" })
-- `new Foo(` returns both the class and its constructor; jump to the first like
-- VS Code does instead of opening a picker
vim.keymap.set("n", "gd", function()
  vim.lsp.buf.definition({
    on_list = function(list)
      vim.fn.setqflist({}, " ", list)
      vim.cmd.cfirst()
    end,
  })
end, { desc = "Go to definition" })

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })
-- Esc steps back through this session's jumps like k9s's back key. The jumplist is
-- otherwise restored from shada, which would walk into previous sessions' files,
-- and `nvim .` leaves an entry for its empty startup buffer that fails with E19.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      vim.api.nvim_win_call(win, function() vim.cmd("clearjumps") end)
    end
  end,
})
vim.keymap.set("n", "<Esc>", function()
  local jumps, pos = unpack(vim.fn.getjumplist())
  for i = pos, 1, -1 do
    local buf = jumps[i].bufnr
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.cmd(("normal! %d\15"):format(pos - i + 1))
      return
    end
  end
end, { desc = "Back" })
vim.keymap.set("n", "<C-c>", "<cmd>confirm qa<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status<cr>", { desc = "Changed files" })
vim.keymap.set("n", "<leader>b", "<cmd>Neotree buffers<cr>", { desc = "Open buffers" })
vim.keymap.set("n", "<leader>x", function() close_buffer() end, { desc = "Close file" })

local float_term = {}
local function toggle_float_term()
  if float_term.win and vim.api.nvim_win_is_valid(float_term.win) then
    vim.api.nvim_win_hide(float_term.win)
    return
  end
  local fresh = not (float_term.buf and vim.api.nvim_buf_is_valid(float_term.buf))
  if fresh then
    float_term.buf = vim.api.nvim_create_buf(false, true)
  end
  local width, height = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
  float_term.win = vim.api.nvim_open_win(float_term.buf, true, {
    relative = "editor",
    border = "rounded",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
  })
  if fresh then
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = function()
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(float_term.buf) then
            vim.api.nvim_buf_delete(float_term.buf, { force = true })
          end
        end)
      end,
    })
    -- A single <C-\> here would swallow <C-\><C-n>; a double tap leaves it working.
    vim.keymap.set("t", "<C-\\><C-\\>", toggle_float_term, { buffer = float_term.buf })
    vim.keymap.set("t", "<Esc>", toggle_float_term, { buffer = float_term.buf })
    vim.keymap.set("t", "<C-\\><Esc>", function()
      vim.api.nvim_chan_send(vim.bo[float_term.buf].channel, "\27")
    end, { buffer = float_term.buf, desc = "Send Esc to the shell" })
    vim.keymap.set("n", "<Esc>", toggle_float_term, { buffer = float_term.buf })
  end
  vim.cmd.startinsert()
end
vim.keymap.set("n", "<leader>\\", toggle_float_term, { desc = "Floating terminal" })

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("]c", function() gs.nav_hunk("next") end, "Next change")
    map("[c", function() gs.nav_hunk("prev") end, "Previous change")
    map("<leader>hp", gs.preview_hunk, "Preview change")
    map("<leader>hs", gs.stage_hunk, "Stage change")
    map("<leader>hr", gs.reset_hunk, "Reset change")
    map("<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("<leader>hB", gs.toggle_current_line_blame, "Toggle inline blame")
  end,
})

require("which-key").setup({})
require("which-key").add({ { "<leader>h", group = "Git changes" } })

require("fzf-lua").setup({})
vim.keymap.set("n", "<C-p>", "<cmd>FzfLua files<cr>", { desc = "Find file" })
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Find file" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Search in files" })
vim.keymap.set("n", "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Symbols in file" })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })
