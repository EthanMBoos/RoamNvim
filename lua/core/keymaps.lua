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

-- Toggle soft-wrap for the current window (handy for wide code, tables, logs)
vim.keymap.set('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('wrap ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = '[U]I: Toggle line [W]rap' })

-- Escape stays a Neovim thing everywhere, including terminal buffers: a single <Esc>
-- drops straight to normal mode with no delay. Trade-off: terminal programs (Claude Code,
-- less, etc.) never receive <Esc> — interrupt/stop Claude with <C-c> from insert mode.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Same navigation from terminal mode (e.g. the Claude Code window): leave terminal mode
-- first, then move — so <C-hjkl> jumps out of the terminal without pressing <Esc> first.
-- This claims all four inside terminals (incl. <C-j>, which Claude uses for newline); fine
-- here since we don't use them in Claude.
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { desc = 'Move focus to the upper window' })

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
