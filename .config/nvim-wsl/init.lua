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
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("vscode").load("dark")

require("leap").create_default_mappings()
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'LeapLabel', { link = 'Search' })

