return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "cpp", "python", "lua", "cmake" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}