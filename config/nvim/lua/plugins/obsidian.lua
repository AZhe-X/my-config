return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "Tower",
        path = "~/Dropbox/10.Kernel/11.Vault/Tower",
      },
      {
        name = "Manifold",
        path = "~/Dropbox/70.Synthesis/71.Program/71.31.Exterior/Manifold",
      },
    },
  },
}
