-- Plugin manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Setup plugins
require("lazy").setup({
  require("plugins.nvim-tree"),
  require("plugins.tokyonight"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.gitsigns"),
  require("plugins.telescope"),
  require("plugins.which-key"),
  require("plugins.lazygit"),
}, {})