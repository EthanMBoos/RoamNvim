-- if true then return {} end -- Uncomment to deactivate

-- codecompanion.nvim — in-editor AI, set up for a plan -> build -> judge loop
-- (after Mitchell Hashimoto's approach). The point isn't that API billing is cheap.
-- It's that the high-level, smart plan is what actually matters, so it's worth the
-- most capable model there is. Any mid-tier model can pound out the little
-- implementation details; paying the top model to write every line would be
-- expensive for little gain.
--
--   1. PLAN  — ask Claude Fable 5 (the most capable model) for the plan, save it
--              to a .md. This is where the intelligence earns its cost.
--   2. BUILD — hand the plan to a Copilot model (e.g. GPT-5.x) via the GitHub
--              Copilot CLI to grind out the code — covered by your Copilot plan.
--   3. JUDGE — before committing, have Fable review the diff.
-- Switch model/adapter live in the chat buffer:
--   * Claude: built-in `anthropic` adapter (needs ANTHROPIC_API_KEY in your shell).
--     Every Claude model — including claude-fable-5 — shows up in the model picker.
--   * OpenAI: Codex on your ChatGPT subscription (no API $$). Needs the `codex-acp`
--     binary on PATH: github.com/zed-industries/codex-acp
return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      -- Both adapters are built in — switch between them in the chat buffer with `ga`
      -- (and `gm` picks the model within an adapter):
      --   anthropic    -> Claude / Fable (needs ANTHROPIC_API_KEY)
      --   copilot_acp  -> GitHub Copilot CLI, agentic (needs `copilot` on PATH + login;
      --                   no API key). Uses your `copilot` terminal login.
      interactions = {
        chat   = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
      adapters = {
        acp = {
          -- The ACP session has no per-message effort toggle like the interactive
          -- `copilot` CLI, so pin reasoning effort in the launch command instead.
          -- Levels: none | minimal | low | medium | high | xhigh | max
          copilot_acp = function()
            return require('codecompanion.adapters').extend('copilot_acp', {
              commands = {
                default = { 'copilot', '--acp', '--stdio', '--effort', 'high' },
              },
            })
          end,
        },
      },
    },
    keys = {
      -- <leader>a{c,s,r} belong to claudecode.nvim.
      { '<leader>aa', '<cmd>CodeCompanionChat Toggle<CR>',        desc = '[A]I ch[A]t toggle' },
      { '<leader>ai', '<cmd>CodeCompanion<CR>', mode = { 'n', 'v' }, desc = '[A]I [I]nline edit' },
    },
  },
}
