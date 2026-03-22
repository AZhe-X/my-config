return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Install parsers
    require("nvim-treesitter").install {
      "markdown", "markdown_inline",
      "python", "typescript", "tsx",
      "javascript", "rust", "lua",
      "json", "yaml", "toml",
      "html", "css", "bash",
      "latex", "typst",
    }

    -- Enable treesitter highlight and folding per filetype
    local filetypes = {
      "markdown", "python", "typescript", "typescriptreact",
      "javascript", "javascriptreact", "rust", "lua", "json",
      "yaml", "html", "css", "bash", "latex", "typst", "toml",
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
