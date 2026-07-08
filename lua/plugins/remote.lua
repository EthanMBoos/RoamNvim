return {
  {
    'amitds1997/remote-nvim.nvim',
    version = '*',
    cmd = {
      'RemoteStart',
      'RemoteStop',
      'RemoteInfo',
      'RemoteCleanup',
      'RemoteConfigDel',
      'RemoteLog',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>rs', '<cmd>RemoteStart<CR>',   desc = '[R]emote [S]tart' },
      { '<leader>ri', '<cmd>RemoteInfo<CR>',    desc = '[R]emote [I]nfo' },
      { '<leader>rx', '<cmd>RemoteStop<CR>',    desc = '[R]emote stop / e[X]it' },
      { '<leader>rc', '<cmd>RemoteCleanup<CR>', desc = '[R]emote [C]leanup' },
      { '<leader>rl', '<cmd>RemoteLog<CR>',     desc = '[R]emote [L]og' },
    },
    opts = {
      devpod = {
        search_style = 'current_dir_only',
      },
    },
  },
}
