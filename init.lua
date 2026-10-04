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

require("bufferline").setup({
  options = {
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
