-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.o.autoindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.clipboard = "unnamedplus"

-- Plugins
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/nvim-mini/mini.icons.git",
  "https://github.com/nvim-mini/mini.statusline.git",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/which-key.nvim.git",
  { src = "https://github.com/Saghen/blink.cmp.git", version = "v1.10.2" },
  "https://github.com/stevearc/oil.nvim.git",
  "https://github.com/nvim-lua/plenary.nvim.git",
  "https://github.com/nvim-telescope/telescope.nvim.git",
  "https://github.com/glidenote/memolist.vim.git",
  "https://github.com/mason-org/mason.nvim.git",
  "https://github.com/mason-org/mason-lspconfig.nvim.git",
})

-- Theme
vim.cmd.colorscheme("catppuccin-mocha")

-- Languages for LSP
local servers = {
  "lua_ls",
  "rust_analyzer",
}

-- Setup
require("oil").setup()
require("which-key").setup()
require("blink.cmp").setup()
require("mini.icons").setup()
require("mini.statusline").setup()
require("telescope").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = servers,
})

-- LSP
vim.lsp.enable(servers)

-- Diagnostics
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
    prefix = "▎",
    spacing = 4,
  },
})

-- Telescope keymap
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope key maps" })
vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "Telescope builtin" })
vim.keymap.set({ "n", "v" }, "<leader>fw", builtin.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Telescope old files" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })

-- Misc keymap
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
