-- Setup for remote servers with two-factor authentication:
--   1. Copy your SSH key to the remote server to skip password prompts:
--      ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-server.com
--   2. You'll need to authenticate once (password + 2FA), then future connections
--      only require 2FA (Duo push, etc.)
--
-- Note: The RemoteStart telescope picker requires entries in ~/.ssh/known_hosts
--       Connect via terminal first if no entries appear: ssh user@remote-server.com

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
      ssh = {
        ssh_config_file_paths = { '$HOME/.ssh/config' },
      },
    },
  },
}
