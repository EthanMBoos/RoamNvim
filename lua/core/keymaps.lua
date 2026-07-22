vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Buffer cycling
vim.keymap.set('n', '<Tab>',     '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>',   '<cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
-- Close the current buffer without leaving a blank window: switch this window to
-- the previous buffer first, then delete the original. Falls back to a plain
-- bdelete (blank window) only when it's the last real buffer.
vim.keymap.set('n', '<leader>x', function()
  local cur = vim.api.nvim_get_current_buf()
  vim.cmd('bprevious')
  if vim.api.nvim_get_current_buf() == cur then
    vim.cmd('bdelete') -- only one buffer left; nothing to switch to
  else
    vim.cmd('bdelete ' .. cur)
  end
end, { desc = 'Close buffer' })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic location list' })

-- Toggle inline diagnostic markers (virtual text / underline / signs) without
-- disabling diagnostics themselves — <leader>sd and <leader>q still work.
local diagnostics_visible = true
vim.keymap.set('n', '<leader>ud', function()
  diagnostics_visible = not diagnostics_visible
  vim.diagnostic.config {
    virtual_text = diagnostics_visible,
    underline = diagnostics_visible and { severity = { min = vim.diagnostic.severity.WARN } } or false,
    signs = diagnostics_visible,
  }
end, { desc = '[U]I: Toggle [D]iagnostic markers' })

-- Exit builtin terminal mode more intuitively
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window splits — matches Ghostty pane keys (ctrl+w prefix, vim convention)
vim.keymap.set('n', '<leader>\\', '<cmd>vsp<CR>',   { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>-',  '<cmd>sp<CR>',    { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>w',  '<cmd>close<CR>', { desc = 'Close current [W]indow' })

-- Window resize — ctrl+shift+hjkl: a direct chord (not a prefix), so holding the key
-- auto-repeats and the split glides. Uses hjkl not arrows because macOS steals ctrl+arrows
-- for Mission Control / Spaces before any app sees them. Mnemonic: ctrl+hjkl navigates,
-- add shift to resize. Ghostty owns ctrl+shift+arrows for its panes and forwards
-- ctrl+shift+hjkl through to Neovim, so the two layers stay separate. (Needs the kitty
-- keyboard protocol to distinguish ctrl+shift from ctrl — Ghostty + Neovim 0.11+ have it.)
vim.keymap.set('n', '<C-S-h>', '<cmd>vertical resize +2<CR>', { desc = 'Grow window width' })
vim.keymap.set('n', '<C-S-l>', '<cmd>vertical resize -2<CR>', { desc = 'Shrink window width' })
vim.keymap.set('n', '<C-S-j>', '<cmd>resize -1<CR>',          { desc = 'Shrink window height' })
vim.keymap.set('n', '<C-S-k>', '<cmd>resize +1<CR>',          { desc = 'Grow window height' })
