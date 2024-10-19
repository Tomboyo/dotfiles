-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local pack = "lazy"
local function bootstrap(url, ref)
    local name = url:gsub(".*/", "")
    local path

    if pack == "lazy" then
        path = vim.fn.stdpath("data") .. "/lazy/" .. name
        vim.opt.rtp:prepend(path)
    else
        path = vim.fn.stdpath("data") .. "/site/pack/".. pack .. "/start/" .. name
    end

    if vim.fn.isdirectory(path) == 0 then
        print(name .. ": installing in data dir...")

        vim.fn.system {"git", "clone", url, path}
        if ref then
            vim.fn.system {"git", "-C", path, "checkout", ref}
        end

        vim.cmd "redraw"
        print(name .. ": finished installing")
    end
end

-- Install tangering and hibiscus. We don't pass a ref so that the version is
-- managed by Lazy (see init.fnl).
bootstrap("https://github.com/udayvir-singh/tangerine.nvim")
bootstrap("https://github.com/udayvir-singh/hibiscus.nvim")

require "tangerine".setup {
  compiler = {
    hooks = {"onsave", "oninit"} 
  }
}

