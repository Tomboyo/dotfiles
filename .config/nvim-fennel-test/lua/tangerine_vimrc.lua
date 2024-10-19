-- :fennel:1729305732
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local lazy = require("lazy")
lazy.setup({install = {colorscheme = {"habamax"}}, checker = {enabled = true}, spec = {"udayvir-singh/tangerine.nvim", "udayvir-singh/hibiscus.nvim", "Mofiqul/vscode.nvim", "ggandor/leap.nvim", "nvim-treesitter/nvim-treesitter"}})
local vscode = require("vscode")
vscode.load("dark")
vim.keymap.set({"n", "x", "o"}, "l", "<Plug>(leap)", {silent = true})
vim.keymap.set({"n", "x", "o"}, "L", "<Plug>(leap-from-window)", {silent = true})
vim.api.nvim_set_hl(0, "LeapBackdrop", {link = "Comment"})
vim.api.nvim_set_hl(0, "LeapLabel", {link = "Search"})
do
  local augid_1_ = vim.api.nvim_create_augroup("netrw", {clear = true})
  local function _2_()
    vim.keymap.set({"n"}, "l", "<Plug>(leap)", {silent = true})
    return vim.keymap.set({"n"}, "L", "<Plug>(leap-from-window)", {silent = true})
  end
  vim.api.nvim_create_autocmd({"filetype"}, {callback = _2_, desc = "Use Leap in netrw", group = augid_1_, pattern = "netrw"})
end
local treesitter = require("nvim-treesitter")
local function _3_(lang, buf)
  local max_file_size = (1000 * 1024)
  local ok_3f, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if (not ok_3f or (stats > max_file_size)) then
    print("File is too large. Treesitter highlighting disabled.")
    return true
  else
    return false
  end
end
return treesitter.setup({ensure_installed = {"fennel"}, auto_install = true, highlight = {enable = true, disable = _3_}})