-- if true then return {} end -- Uncomment to deactivate

-- avante.nvim — in-editor AI for a plan -> build -> judge loop:
--   1. PLAN  — Fable 5 writes the plan.
--   2. BUILD — a Copilot model (GPT-5.x) writes the code on your Copilot subscription.
--   3. JUDGE — back to Fable to review the diff.
--
-- <leader>ap :AvanteSwitchProvider — switch provider/billing (claude <-> copilot).
-- <leader>a? :AvanteModels         — pick a model. This lists models from ALL providers
--            combined; picking one switches to its provider + model together.
--
-- Copilot is opt-in per machine: only wired up when ROAM_COPILOT=1 is set.

local enable_copilot = vim.env.ROAM_COPILOT == '1'

-- Copilot's API advertises hundreds of models, but only the ones enabled on YOUR plan
-- actually work — the rest error with "model_not_supported". Avante shows the whole live
-- list by default, so we replace it with this whitelist and :AvanteModels only offers
-- these. Curated to the newest flagship of each family that's enabled on your plan.
-- To see the full live list + each model's enabled/disabled status, query
--   https://api.githubcopilot.com/models  with your Copilot token.
local copilot_models = {
  'gpt-5.6-terra', -- newest GPT (default)
  'gpt-5.6-luna',
  'claude-opus-4.5',
  'claude-sonnet-5',
  'gemini-3.1-pro-preview',
}

local dependencies = {
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  'nvim-tree/nvim-web-devicons', -- file icons in the UI
  -- Lightweight input UI for the avante prompt. `select` is disabled so it leaves
  -- vim.ui.select to your telescope-ui-select setup.
  { 'stevearc/dressing.nvim', opts = { select = { enabled = false } } },
  -- Paste images straight into prompts.
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = { insert_mode = true },
      },
    },
  },
  -- Renders avante's responses as formatted markdown instead of raw text.
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = { file_types = { 'markdown', 'Avante' } },
    ft = { 'markdown', 'Avante' },
  },
}

if enable_copilot then
  table.insert(dependencies, {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  })
end

return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    dependencies = dependencies,
    keys = enable_copilot and {
      { '<leader>ap', '<cmd>AvanteSwitchProvider<CR>', desc = 'AI switch [P]rovider (claude<->copilot)' },
    } or {},
    opts = {
      provider = 'claude',
      providers = {
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-fable-5',
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
      selector = {
        provider = 'telescope', -- use telescope for model/file pickers (you have it)
      },
      input = {
        provider = 'dressing', -- nicer prompt box
      },
      windows = {
        width = 25, -- wider sidebar (% of available width)
        sidebar_header = {
          include_model = true, -- show active model in the sidebar header
        },
      },
    },
    config = function(_, opts)
      if enable_copilot then
        -- Use avante's native copilot provider (OAuth via ~/.config/github-copilot).
        -- Do NOT set __inherited_from = "openai": that uses API-key auth and fails.
        -- Pick a model at runtime with :AvanteModels.
        opts.providers.copilot = {
          model = 'gpt-5.6-terra',
          extra_request_body = {
            reasoning_effort = 'high', -- high effort for the reasoning-capable models
          },
        }
      end

      -- Fable 5 uses always-on thinking, so Anthropic rejects `temperature`. Avante
      -- only strips it for models its regex knows, which misses fable — so teach it.
      local claude = require('avante.providers.claude')
      local is_temp_unsupported = claude.is_temperature_unsupported
      claude.is_temperature_unsupported = function(model)
        if model and model:match('claude%-fable%-[4-9]') then return true end
        return is_temp_unsupported(model)
      end

      require('avante').setup(opts)

      if enable_copilot then
        -- Replace copilot's live /models query with our whitelist. avante's model
        -- selector uses list_models as-is when it returns a static table, so this is
        -- all that :AvanteModels will offer for copilot.
        local copilot = require('avante.providers.copilot')
        copilot.list_models = function()
          return vim.tbl_map(function(id)
            return { id = id, name = id, display_name = id }
          end, copilot_models)
        end
      end
    end,
  },
}
