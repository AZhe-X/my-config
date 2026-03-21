return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
    float = {
      max_width = 0.8,
      max_height = 0.8,
    },
  },
  keys = {
    { "<leader>dd", "<cmd>Oil --float<cr>", desc = "Open directory (float)" },
    { "<leader>dx", function() require("oil").close() end, desc = "Close oil" },
  },
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
}
