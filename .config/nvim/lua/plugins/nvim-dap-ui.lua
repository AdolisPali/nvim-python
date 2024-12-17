return {
  'rcarriga/nvim-dap-ui',
  lazy = false,
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
    'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
  },
  opts = {
    controls = {
      element = "repl",
      enabled = false,
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.50 },
          { id = "stacks", size = 0.30 },
          { id = "watches", size = 0.10 },
          { id = "breakpoints", size = 0.10 },
        },
        size = 40,
        position = "left",  -- Can be "left" or "right"
      },
      {
        elements = { "repl", "console" },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      }
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t",
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  },
  config = function(_, opts)
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup(opts)

    vim.api.nvim_set_hl(0, "DapStoppedHl", { fg = "#98BB6C", bg = "#2A2A2A", bold = true })
    vim.api.nvim_set_hl(0, "DapStoppedLineHl", { bg = "#204028", bold = true })

    vim.fn.sign_define('DapStopped', { text = 'S', texthl = 'DapStoppedHl', linehl = 'DapStoppedLineHl', numhl = '' }) -- Stopped
    vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }) -- Breakpoint
    vim.fn.sign_define('DapBreakpointCondition', { text = 'C', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' }) -- Conditional Breakpoint
    vim.fn.sign_define('DapBreakpointRejected', { text = 'R', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }) -- Rejected Breakpoint
    vim.fn.sign_define('DapLogPoint', { text = 'L', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' }) -- Log Point

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Key mappings for DAP actions
    local map = vim.api.nvim_set_keymap
    local keymap_opts = { noremap = true, silent = true }

    -- General DAP shortcuts
    map('n', '<F5>', '<Cmd>lua require("dap").continue()<CR>', keymap_opts)  -- Continue
    map('n', '<F6>', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', keymap_opts)  -- Toggle breakpoint
    map('n', '<F10>', '<Cmd>lua require("dap").step_over()<CR>', keymap_opts)  -- Step over
    map('n', '<F11>', '<Cmd>lua require("dap").step_into()<CR>', keymap_opts)  -- Step into
    map('n', '<F12>', '<Cmd>lua require("dap").step_out()<CR>', keymap_opts)  -- Step out

    -- Toggle DAP UI with F4
    map('n', '<F4>', '<Cmd>lua require("dapui").toggle()<CR>', keymap_opts)
  end
}
