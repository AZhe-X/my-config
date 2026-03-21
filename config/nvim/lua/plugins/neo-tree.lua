return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
  },
  keys = {
    { "<leader>ds", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
  },
  lazy = false,
}
