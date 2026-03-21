return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    vim.lsp.config("basedpyright", {})
    vim.lsp.config("eslint", {})
    vim.lsp.config("vtsls", {})
    vim.lsp.config("rust_analyzer", {})
    vim.lsp.config("texlab", {})
    vim.lsp.config("tinymist", {})
    vim.lsp.config("marksman", {})

    vim.lsp.enable({
      "basedpyright",
      "eslint",
      "vtsls",
      "rust_analyzer",
      "texlab",
      "tinymist",
      "marksman",
    })
  end,
}
