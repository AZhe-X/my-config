return {
  -- Syntax highlighting for Wolfram/Mathematica files
  {
    "voldikss/vim-mma",
    ft = { "mma", "wl" },
  },

  -- Wolfram Language Server via Mathematica's built-in LSPServer
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.filetype.add({
        extension = {
          wl = "wl",
          wls = "wl",
          m = "mma",
        },
      })

      vim.lsp.config("wolfram", {
        cmd = {
          "/Applications/Wolfram.app/Contents/MacOS/WolframKernel",
          "-noprompt",
          "-run",
          'Needs["LSPServer`"]; LSPServer`StartServer[]',
        },
        filetypes = { "mma", "wl" },
        root_markers = { ".git" },
        on_attach = function(client)
          -- Wolfram LSPServer sends an invalid semanticTokensProvider
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      vim.lsp.enable("wolfram")
    end,
  },
}
