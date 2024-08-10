vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.opt.relativenumber = true
vim.opt.number = true
vim.cmd([[
  augroup NumberToggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]])

