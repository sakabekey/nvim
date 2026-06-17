-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.o.autoindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.scrolloff = 1
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250

-- For nvim-tree plugin, see :help nvim-tree-netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-mini/mini.statusline" },
  { "neovim/nvim-lspconfig" },
  { "folke/which-key.nvim" },
  { "Saghen/blink.cmp", version = "v1.10.2" },
  { "stevearc/oil.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "glidenote/memolist.vim" },
  { "mason-org/mason.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
  { "j-hui/fidget.nvim" },
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-mini/mini.surround" },
  { "nvim-mini/mini.align" },
  { "lewis6991/gitsigns.nvim" },
  { "nvim-mini/mini.pairs" },
  { "nvim-mini/mini.cursorword" },
}, {
  defaults = {
    lazy = false,
  },
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
require("mini.statusline").setup()
require("fidget").setup()
require("nvim-tree").setup()
require("mini.surround").setup()
require("mini.align").setup()
require("mini.pairs").setup()
require("mini.cursorword").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  handlers = {
    function(server)
      require("lspconfig")[server].setup({})
    end,
  },
})
require("telescope").setup({
  defaults = {
    preview = { treesitter = false, },
  },
  pickers = {
    find_files = {
      path_display = { "relative" },
    },
    buffers = {
      path_display = { "smart" },
    },
  },
})
require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  completion = {
    documentation = { auto_show = true },
  },
})
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

-- LSP
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" }, },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), },
    },
  },
})

-- Diagnostics
vim.diagnostic.config({
  -- virtual_lines = {
  --   current_line = true,
  --   prefix = "▎",
  --   spacing = 4,
  -- },
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
})

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- memolist
vim.g.memolist_memo_suffix = "md"
vim.g.memolist_filename_date = "%Y%m%d_"

-- Telescope keymap
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fk", telescope_builtin.keymaps, { desc = "Telescope key maps" })
vim.keymap.set("n", "<leader>fs", telescope_builtin.builtin, { desc = "Telescope builtin" })
vim.keymap.set({ "n", "v" }, "<leader>fw", telescope_builtin.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fd", telescope_builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fr", telescope_builtin.resume, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>f.", telescope_builtin.oldfiles, { desc = "Telescope old files" })
vim.keymap.set("n", "<leader>fc", telescope_builtin.commands, { desc = "Telescope commands" })
vim.keymap.set('n', '<leader><leader>', telescope_builtin.buffers, { desc = 'Telescope buffers' })

-- LSP keymap
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, {
        buffer = ev.buf,
        desc = desc,
      })
    end
    -- jump
    map("gd", vim.lsp.buf.definition, "definition")
    map("gD", vim.lsp.buf.declaration, "declaration")
    map("gr", function()
      telescope_builtin.lsp_references({
        path_display = function(_, path)
          return vim.fn.fnamemodify(path, ":.")
        end,
      })
    end, "references")
    map("gi", telescope_builtin.lsp_implementations, "implementation")
    map("gy", telescope_builtin.lsp_type_definitions, "type definition")
    -- information
    map("K", vim.lsp.buf.hover, "hover")
    map("zK", vim.lsp.buf.signature_help, "signature")
    -- edit
    map("gR", vim.lsp.buf.rename, "rename")
    map("ga", vim.lsp.buf.code_action, "code action")
    -- diagnostics
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "prev diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "next diagnostic")
    map("gl", vim.diagnostic.open_float, "line diagnostic")
    map("gL", telescope_builtin.diagnostics, "diagnostics list")
    -- Rust
    map("gz", vim.lsp.buf.code_action, "rust action")
  end,
})

-- Misc keymap
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", function() vim.cmd("nohlsearch") end)
