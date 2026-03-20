vim.opt.number = true
vim.opt.showmatch = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.expandtab = true
vim.opt.conceallevel = 1

-- Keymaps
vim.keymap.set("n", "<leader>c0", function() vim.opt.conceallevel = 0 end, { desc = "Conceal level 0 (raw)" })
vim.keymap.set("n", "<leader>c1", function() vim.opt.conceallevel = 1 end, { desc = "Conceal level 1 (placeholder)" })
vim.keymap.set("n", "<leader>c2", function() vim.opt.conceallevel = 2 end, { desc = "Conceal level 2 (hidden)" })

require("config.lazy")
