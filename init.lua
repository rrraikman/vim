vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.opt.packpath = vim.opt.runtimepath:get()
vim.cmd.source("~/.vimrc")

vim.g.mapleader = " "

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  { src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("4") },
  "https://github.com/neovim/nvim-lspconfig",
})

require("neo-tree").setup({
  close_if_last_window = true,
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
  if vim.bo[bufnr].modified then
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
  vim.cmd.bdelete(tostring(bufnr))
end

require("bufferline").setup({
  options = {
    close_command = close_buffer,
    right_mouse_command = close_buffer,
    offsets = { { filetype = "neo-tree", text = "Explorer", separator = true } },
  },
})

vim.lsp.enable("ts_ls")
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
vim.keymap.set("n", "<leader>g", "<cmd>Neotree git_status<cr>", { desc = "Changed files" })
vim.keymap.set("n", "<leader>b", "<cmd>Neotree buffers<cr>", { desc = "Open buffers" })
vim.keymap.set("n", "<leader>x", function() close_buffer() end, { desc = "Close file" })
