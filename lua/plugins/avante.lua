-- if true then return {} end -- Uncomment to deactivate

-- avante.nvim — in-editor AI, set up for a plan -> build -> judge loop
-- (after Mitchell Hashimoto's approach). The plan is the part that matters, so it gets
-- the strongest model. The rest is routine code a cheaper model can write; paying the
-- top model per line isn't worth it.
--
--   1. PLAN  — ask Fable 5 for the plan, save it to a .md.
--   2. BUILD — hand the plan to a Copilot model (e.g. GPT-5.x) to write the code,
--              on your Copilot subscription.
--   3. JUDGE — switch back to Fable to review the diff before committing.
--
-- Keymaps are avante's defaults (under <leader>a*); claudecode.nvim moved to
-- <leader>c{c,s,r} to make room. See `:h avante` for the full list.
--
-- Two billing paths, one per "provider":
--   * claude  -> Anthropic API, needs ANTHROPIC_API_KEY in your shell. Pay per token;
--                used for plan and judge. The default, always on.
--   * copilot -> GitHub Copilot subscription, no API key. Used for the build.
--
-- Two pickers — don't confuse them:
--   * provider picker  :AvanteSwitchProvider (<leader>ap) — flips the backend, and thus
--                       the billing path: claude <-> copilot. This is the plan/judge vs
--                       build switch. The only command that changes what you're paying.
--   * model picker      :AvanteModels (<leader>a?) — changes the model WITHIN the current
--                       provider. Never switches provider, never triggers auth. On claude
--                       it lists what you set below; on copilot it lists the subscription's
--                       models (GPT-5.x, etc.). Picking a model here is always free/safe.
--
-- COPILOT IS OPT-IN PER MACHINE. It's only wired up when ROAM_COPILOT=1 is set in your
-- shell — set it at home, leave it UNSET at work. When unset: copilot.lua isn't
-- installed, the copilot provider isn't configured, and <leader>ap isn't mapped.
-- The real safety is copilot.lua being absent: no copilot.lua means no `:Copilot auth`
-- and no token machinery, so a GitHub login can't complete. (:AvanteSwitchProvider is
-- avante's own command and still exists; its picker may even list a copilot entry from
-- avante's defaults, but selecting it just errors — it can't link your account.)
local enable_copilot = vim.env.ROAM_COPILOT == '1'

local dependencies = {
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
}

local providers = {
  claude = {
    endpoint = 'https://api.anthropic.com',
    -- Strongest model, for plan + judge. If your org is zero-data-retention,
    -- Fable returns a 400 — use 'claude-opus-4-8' as the top model instead.
    model = 'claude-fable-5',
  },
}

-- avante has no default mapping for switching provider, so add the one extra key —
-- only when copilot is in play (otherwise there's just one provider to switch to).
local keys = {}
if enable_copilot then
  table.insert(dependencies, 'zbirenbaum/copilot.lua') -- supplies the Copilot OAuth token
  -- Build step, on the Copilot subscription. gpt-5.5 is the current workhorse — swap the
  -- string as models move, pick another live in :AvanteModels, or replace this whole
  -- provider block if you move the build to a different backend. Only rule for the build
  -- provider: it must bill flat (a subscription), not per-token like claude above.
  providers.copilot = { model = 'gpt-5.5' }
  table.insert(keys, {
    '<leader>ap', '<cmd>AvanteSwitchProvider<CR>', desc = 'AI switch [P]rovider (claude<->copilot)',
  })
end

return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy', -- load after startup so avante installs its default <leader>a* maps
    -- `make` fetches the prebuilt companion binary (no Rust toolchain needed).
    build = vim.fn.has('win32') ~= 0
      and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
      or 'make',
    dependencies = dependencies,
    keys = keys,
    opts = {
      provider = 'claude', -- Claude/API is the default; copilot is a deliberate switch.
      providers = providers,
      behaviour = {
        auto_suggestions = false, -- no ghost-text completion; this is a chat/edit tool
      },
    },
  },
}
