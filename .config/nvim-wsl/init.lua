-- Bootstrap the lazy plugin manager
-- https://github.com/folke/lazy.nvim
-- https://lazy.folke.io/installation
require("config.lazy-bootstrap")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.expandtab = true
vim.o.tabstop = 2    -- spaces per tab
vim.o.shiftwidth = 2 -- spaces per indent level

-- Setup lazy.nvim
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require("lazy").setup({
  spec = {
    {
      {
        "ggandor/leap.nvim",
         dependencies = {
          "tpope/vim-repeat",
        },
      },
      "Mofiqul/vscode.nvim",
      "Olical/conjure",
      "williamboman/mason.nvim", -- installs language servers (:MasonInstall my-lsp)
      "nvim-treesitter/nvim-treesitter", -- language parsing support, used by conjure but not a hard dep
      {
        "clojure-vim/vim-jack-in", -- provides :Clj command to start nREPL server
        dependencies = {
          "tpope/vim-dispatch",
        },
      }
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("vscode").load("dark")
require("mason").setup()

require("leap").create_default_mappings()
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'LeapLabel', { link = 'Search' })

