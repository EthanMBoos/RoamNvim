vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('trim-whitespace', { clear = true }),
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[%s/\s\+$//e]]
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Auto-reload buffers when the file changes on disk (e.g. edited by another tool).
-- autoread only reloads when Neovim re-checks the timestamp, so nudge it on these events.
local reload = vim.api.nvim_create_augroup('auto-reload-file', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = reload,
  callback = function()
    -- Skip command-line window and unnamed/special buffers where checktime errors
    if vim.fn.getcmdwintype() == '' and vim.bo.buftype == '' then
      vim.cmd('checktime')
    end
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = reload,
  callback = function()
    vim.notify('File changed on disk — buffer reloaded', vim.log.levels.INFO)
  end,
})
