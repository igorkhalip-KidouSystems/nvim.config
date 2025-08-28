return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "pyright", "lua_ls" },
    })
    
    local lspconfig = require("lspconfig")
    lspconfig.clangd.setup({})
    lspconfig.pyright.setup({})
    lspconfig.lua_ls.setup({})
  end,
}