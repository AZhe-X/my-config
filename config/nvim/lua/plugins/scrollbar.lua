return {
  "petertriho/nvim-scrollbar",
  event = "BufReadPost",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "kevinhwang91/nvim-hlslens",
  },
  config = function()
    require("scrollbar").setup({
      handlers = {
        cursor = false,
        gitsigns = true,
        search = true,
      },
    })
    require("scrollbar.handlers.gitsigns").setup()
    require("scrollbar.handlers.search").setup()
  end,
}
