-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.lualine.style = "lvim"

local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_z = { components.python_env }
lvim.builtin.lualine.sections.lualine_c = { components.filename }

lvim.colorscheme = "kanagawa-lotus"

local pythonPath = function()
  local cwd = vim.loop.cwd()
  -- return "/Users/olegmaslo/PycharmProjects/Cyberworld/venv/bin/python"
  if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
    return cwd .. '/.venv/bin/python'
  else
    return '/usr1/bin/python'
  end
end

lvim.plugins = {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {           -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "lotus", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus"
        },
      })
    end
  },
  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
  {
    "mistweaverco/kulala.nvim",
    config = function()
      require('kulala').setup(
        {
          default_view = "body",
          -- dev, test, prod, can be anything
          -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
          default_env = "dev",
          -- enable/disable debug mode
          debug = false,
          -- default formatters for different content types
          formatters = {
            json = { "jq", "." },
            xml = { "xmllint", "--format", "-" },
            html = { "xmllint", "--format", "--html", "-" },
          },
          -- default icons
          icons = {
            inlay = {
              loading = "⏳",
              done = "✅",
              error = "❌",
            },
            lualine = "🐼",
          },
          -- additional cURL options
          -- see: https://curl.se/docs/manpage.html
          additional_curl_options = {},
        }
      )
    end
  },
  "ChristianChiarulli/swenv.nvim",
  "stevearc/dressing.nvim",
  {
    "AckslD/swenv.nvim",
    config = function()
      require('swenv').setup({
        -- Should return a list of tables with a `name` and a `path` entry each.
        -- Gets the argument `venvs_path` set below.
        -- By default just lists the entries in `venvs_path`.
        get_venvs = function(venvs_path)
          return require('swenv.api').get_venvs(venvs_path)
        end,
        -- Path passed to `get_venvs`.
        venvs_path = vim.fn.expand('~/venvs'),
        -- Something to do after setting an environment
        post_set_venv = nil,
      })
    end
  },
  "stevearc/dressing.nvim",
  "nvim-neotest/neotest",
  "nvim-neotest/neotest-python",
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
          program = vim.loop.cwd(),
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

lvim.builtin.which_key.mappings["P"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
  d = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show Env" },
  s = { "<cmd>lua require('swenv.api').set_venv('venv')<cr>", "Set Env" },

}

require('swenv').setup({
  post_set_venv = function()
    vim.cmd("LspRestart")
  end,
})

lvim.builtin.which_key.mappings["C"] = {
  name = "Kulala",
  s = { "<cmd>lua require('kulala').run()<cr>", "Send selected request" },
  k = { "<cmd>lua require('kulala').jump_next()<cr>", "Next request" },
  j = { "<cmd>lua require('kulala').jump_prev()<cr>", "Previous request" },

}


lvim.builtin.which_key.mappings["M"] = {
  name = "Curl",
  c = { "<cmd>lua require('curl').open_curl_tab()<cr>", "Send selected request" },

}
