return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-tree").setup({
      filters = {
        git_ignored = false,
        custom = { "^venv$", "^\\.venv$" },
      },
    })
  end,
}