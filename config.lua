-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.lualine.style = "lvim"

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_z = { components.python_env }
lvim.builtin.lualine.sections.lualine_c = { components.filename }

local pythonPath = function()
  local cwd = vim.loop.cwd()
  return "/Users/olegmaslo/PycharmProjects/Cyberworld/venv/bin/python"
  -- if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
  --   return cwd .. '/.venv/bin/python'
  -- else
  --   return '/usr1/bin/python'
  -- end
end

lvim.plugins = {
   "AckslD/swenv.nvim" ,
   "stevearc/dressing.nvim" ,
   "nvim-neotest/neotest" ,
   "nvim-neotest/neotest-python" ,
  {
    "mfussenegger/nvim-dap",
    config = function()
      local ok, dap = pcall(require, "dap")
      if not ok then
        return
      end
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = pythonPath()
        },
        {
          type = 'python',
          request = 'launch',
          name = 'DAP Django',
          program = '${workspaceFolder}/src/api/manage.py',
          args = { 'runserver', '--noreload' },
          justMyCode = true,
          django = true,
          console = "integratedTerminal",
        },
      }
      dap.adapters.python = {
        type = 'executable',
        command = pythonPath(),
        args = { '-m', 'debugpy.adapter' }
      }
    end,
  },

  { "tpope/vim-fugitive" },

}

-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py" }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

-- setup debug adapter
lvim.builtin.dap.active = true


lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }


-- binding for switching
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}
