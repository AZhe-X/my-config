vim.opt.number = true
vim.opt.showmatch = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.expandtab = true
vim.opt.conceallevel = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() vim.opt_local.conceallevel = 2 end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Keymaps
vim.keymap.set("n", "<leader>c0", function() vim.opt_local.conceallevel = 0 end, { desc = "Conceal level 0 (raw)" })
vim.keymap.set("n", "<leader>c1", function() vim.opt_local.conceallevel = 1 end, { desc = "Conceal level 1 (placeholder)" })
vim.keymap.set("n", "<leader>c2", function() vim.opt_local.conceallevel = 2 end, { desc = "Conceal level 2 (hidden)" })
vim.keymap.set("n", "<leader>c3", function() vim.opt_local.conceallevel = 3 end, { desc = "Conceal level 3 (fully hidden)" })

require("config.lazy")
