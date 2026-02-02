return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
        file_ignore_patterns = { "^venv/", "^%.venv/" },
      },
      pickers = {
        find_files = {
          no_ignore = true,
        },
        live_grep = {
          additional_args = { "--no-ignore" },
        },
      },
    })
  end,
}