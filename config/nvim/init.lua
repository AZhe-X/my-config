-- Settings
vim.opt.number = true          -- Show line numbers
vim.opt.showmatch = true       -- Highlight matching brackets
vim.opt.tabstop = 4            -- Tab width
vim.opt.shiftwidth = 4         -- Indent width
vim.opt.smartcase = true       -- Case-sensitive search when uppercase is used
vim.opt.ignorecase = true      -- Case-insensitive search (needed for smartcase)
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.conceallevel = 0       -- Show raw text globally
vim.opt.clipboard = "unnamedplus" -- Share clipboard with system
vim.opt.autoread = true        -- Auto-reload files changed outside nvim
vim.opt.foldlevel = 99         -- Start with all folds open

-- Auto-reload files when switching back to nvim or idle
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- Render markdown formatting (wiki links, bold, etc.) cleanly
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() vim.opt_local.conceallevel = 2 end,
})

-- Leader keys (must be set before loading lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Keymaps: toggle conceal level per buffer
vim.keymap.set("n", "<leader>c0", function() vim.opt_local.conceallevel = 0 end, { desc = "Conceal level 0 (raw)" })
vim.keymap.set("n", "<leader>c1", function() vim.opt_local.conceallevel = 1 end, { desc = "Conceal level 1 (placeholder)" })
vim.keymap.set("n", "<leader>c2", function() vim.opt_local.conceallevel = 2 end, { desc = "Conceal level 2 (hidden)" })
vim.keymap.set("n", "<leader>c3", function() vim.opt_local.conceallevel = 3 end, { desc = "Conceal level 3 (fully hidden)" })

-- Load plugins
require("config.lazy")
