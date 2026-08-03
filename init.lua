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

-- Languages for LSP
local servers = {
  "lua_ls",
  "rust_analyzer",
}

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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-mini/mini.statusline",
    event = "VeryLazy",
    config = function()
      require("mini.statusline").setup()
    end,
  },
  { "neovim/nvim-lspconfig" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
  {
    "Saghen/blink.cmp",
    version = "v1.10.2",
    event = "InsertEnter",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
        },
        completion = {
          documentation = { auto_show = true },
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          preview = { treesitter = false },
          layout_config = {
            width = { padding = 0 },
            height = { padding = 0 },
          },
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
    end,
  },
  {
    "glidenote/memolist.vim",
    lazy = false,
    init = function()
      vim.g.memolist_memo_suffix = "md"
      vim.g.memolist_filename_date = "%Y%m%d_"
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        handlers = {
          function(server)
            require("lspconfig")[server].setup({})
          end,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      require("fidget").setup()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",
    config = function()
      require("mini.align").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
    end,
  },
  {
    "nvim-mini/mini.cursorword",
    event = "VeryLazy",
    config = function()
      require("mini.cursorword").setup()
    end,
  },
}, {
  defaults = {
    lazy = true,
  },
})

-- LSP
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" }, },
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
local function telescope_builtin()
  return require("telescope.builtin")
end

vim.keymap.set("n", "<leader>ff", function() telescope_builtin().find_files() end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", function() telescope_builtin().live_grep() end, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", function() telescope_builtin().buffers() end, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", function() telescope_builtin().help_tags() end, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fk", function() telescope_builtin().keymaps() end, { desc = "Telescope key maps" })
vim.keymap.set("n", "<leader>fs", function() telescope_builtin().builtin() end, { desc = "Telescope builtin" })
vim.keymap.set({ "n", "v" }, "<leader>fw", function() telescope_builtin().grep_string() end, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fd", function() telescope_builtin().diagnostics() end, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fr", function() telescope_builtin().resume() end, { desc = "Telescope resume" })
vim.keymap.set("n", "<leader>f.", function() telescope_builtin().oldfiles() end, { desc = "Telescope old files" })
vim.keymap.set("n", "<leader>fc", function() telescope_builtin().commands() end, { desc = "Telescope commands" })
vim.keymap.set("n", "<leader><leader>", function() telescope_builtin().buffers() end, { desc = "Telescope buffers" })

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
      telescope_builtin().lsp_references({
        path_display = function(_, path)
          return vim.fn.fnamemodify(path, ":.")
        end,
      })
    end, "references")
    map("gi", function() telescope_builtin().lsp_implementations() end, "implementation")
    map("gy", function() telescope_builtin().lsp_type_definitions() end, "type definition")
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
    map("gL", function() telescope_builtin().diagnostics() end, "diagnostics list")
    -- Rust
    map("gz", vim.lsp.buf.code_action, "rust action")
  end,
})

-- Misc keymap
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", function() vim.cmd("nohlsearch") end)
