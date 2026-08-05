vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {"catppuccin/nvim", name = "catppuccin", priority = 1000},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"williamboman/mason.nvim", build = ":MasonUpdate"},
  {"williamboman/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/nvim-cmp", dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  }},
  {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "MunifTanjim/nui.nvim", 
  }},
  {"nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = {"nvim-lua/plenary.nvim"}},
})

vim.cmd.colorscheme("catppuccin-mocha")

-- Plagin configurations
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls" }, -- Языки, которые хотим автоматически установить
  automatic_installation = true,
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  },
})

-- Search
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Keybindings
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {desc = "Toggle file explorer"})
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {desc = "Find files"})
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", {desc = "Find text"})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "Go to definition"})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "Hover info"})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc = "Rename symbol"})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})

vim.keymap.set("i", "<Up>", "<Nop>")
vim.keymap.set("i", "<Down>", "<Nop>")
vim.keymap.set("i", "<Left>", "<Nop>")
vim.keymap.set("i", "<Right>", "<Nop>")
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true })