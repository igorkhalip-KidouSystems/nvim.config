return {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add({
      { "<leader>f", group = "Find" },
      { "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fb", desc = "Find buffers" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>e", desc = "Toggle file explorer" },
      { "<leader>q", desc = "Open diagnostic quickfix list" },
    })
  end,
}