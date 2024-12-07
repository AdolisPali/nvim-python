return {
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  lazy = false,
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function ()
    require('dap-python').setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
  end
}
