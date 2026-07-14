-- if true then return {} end -- Uncomment to deactivate

-- Auth (either one. The CLI just needs to be authenticated):
--   * Subscription: run `claude` once from a terminal after installing the CLI. It
--     opens a browser to log in; the plugin then connects to that session.
--   * API key: To pin it instead of relying on the shell, add an `env` block to
--   ~/.claude/settings.json: { "env": { "ANTHROPIC_API_KEY": "sk-ant-..." } }
return {
  {
    'coder/claudecode.nvim',
    opts = {},
    keys = {
      -- On <leader>c* so avante.nvim can own its default <leader>a* maps.
      { '<leader>cc', '<cmd>ClaudeCode<CR>',          desc = '[C]laude [C]ode toggle' },
      { '<leader>cs', '<cmd>ClaudeCodeSend<CR>',      mode = 'v', desc = '[C]laude [S]end selection' },
      { '<leader>cr', '<cmd>ClaudeCode --resume<CR>', desc = '[C]laude [R]esume session' },
    },
  },
}
