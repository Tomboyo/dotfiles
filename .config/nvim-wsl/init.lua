-- Bootstrap the lazy plugin manager
-- https://github.com/folke/lazy.nvim
-- https://lazy.folke.io/installation
require("config.lazy-bootstrap")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.expandtab = true
vim.o.tabstop = 2    -- spaces per tab
vim.o.shiftwidth = 1 -- spaces per indent level
vim.o.textwidth = 80 -- max line length

-- Setup lazy.nvim
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require("lazy").setup({
  spec = {
    {
      {
        "ggandor/leap.nvim", -- jump to where you're looking with ~4 keys
         dependencies = {
          "tpope/vim-repeat",
        },
      },
      "Mofiqul/vscode.nvim",
      "Olical/conjure", -- nREPL support for tons of langs
      {
        "guns/vim-sexp", -- lisp s-expression mappings 
        "tpope/vim-sexp-mappings-for-regular-people", 
      },
      "williamboman/mason.nvim", -- installs language servers (:MasonInstall my-lsp)
      "tpope/vim-surround", -- editing tool for dealing with parens, html tags, etc.
      "nvim-treesitter/nvim-treesitter", -- language parsing support, used by conjure but not a hard dep
      {
        "neovim/nvim-lspconfig", -- configuration default for various language servers
        'hrsh7th/cmp-nvim-lsp', -- cmp-* is for LSP completion support.
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        'SirVer/ultisnips', -- snip support (the thing where "today" turns into a date-time in the editor)
        'quangnguyen30192/cmp-nvim-ultisnips', -- interop with cmp
      },
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

-- Color theme plugin.
require("vscode").load("dark")

-- Provides :MasonInstall to install language servers.
require("mason").setup()

-- Leap configs
-- These three are the same as require("leap").create_default_mappings()
-- Note that s, S, and gs clobber some tpope/vim-surround keybinds. (Not sure how to fix atm.)
vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'LeapLabel', { link = 'Search' })

-- Netrw (directory browser) mappings.
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Override ntrw mappings to use Leap motions',
  callback = function()
    vim.keymap.set({'n'}, 's', '<Plug>(leap-forward)', {remap = true, buffer = true})
    vim.keymap.set({'n'}, 'S', '<Plug>(leap-backward)', {remap = true, buffer = true})
  end
})

-- Completion support.
require("config.nvim-cmp")

-- Set up code action keybind. I think this is usually done by default but
-- might depend on the lsp client (Conjure in this case).
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method("textDocument/codeAction") then
      vim.keymap.set({'n', 'i'}, 'gra', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    end

    -- Make gd perform lsp "go to definition"
    vim.keymap.set({'n'}, 'gd', '<C-]>')

    -- Diagnostics
    vim.keymap.set({'n','i'}, '<C-W>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
    vim.keymap.set({'n'}, ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    vim.keymap.set({'n'}, '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')


  end
})

vim.api.nvim_create_user_command('Cljd',
 function()
  vim.cmd("Clj -J-Djdk.attach.allowAttachSelf")
 end,
 { nargs = 0 })
