local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result and result.diagnostics then
              result.diagnostics = vim.tbl_filter(function(diag)
                local msg = (diag.message or ""):lower()
                -- Filter out marksman's "non-existent" link warnings
                return not msg:match("non%-existent") and not msg:match("non existent")
              end, result.diagnostics)
            end
            original_handler(err, result, ctx, config)
          end,
        },
      },
    },
  },
}
