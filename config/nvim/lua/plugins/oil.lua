return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = false,
    float = {
      max_width = 0.8,
      max_height = 0.8,
    },
  },
  keys = {
    { "<leader>fo", "<cmd>Oil --float<cr>", desc = "Open directory (Oil)" },
  },
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
}
