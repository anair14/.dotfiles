-- Lazy.nvim setup
local lazypath = vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--single-branch', 'https://github.com/folke/lazy.nvim', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to space
vim.g.mapleader = " "

-- Lazy.nvim setup
require("lazy").setup({
  -- Dashboard Plugin Setup
  {
    'glepnir/dashboard-nvim',
    lazy = false,
    config = function()
      local dashboard = require("dashboard")
      dashboard.custom_header = {
        "    N   N   V   V   K   K   ",
        "    NN  N   V   V   K  K    ",
        "    N N N   V   V   K K     ",
        "    N  NN   V V    KK       ",
        "    N   N   V V    K K      ",
        "    N   N   V V    K  K     ",
        "    N   N   V V    K   K    "
      }
      dashboard.custom_footer = function()
        return "NVK - Time: " .. os.date('%H:%M:%S')
      end
      dashboard.custom_center = {
        {icon = '  ', desc = 'Find File', action = 'Telescope find_files'},
        {icon = '  ', desc = 'File Explorer', action = 'NvimTreeToggle'},
        {icon = '  ', desc = 'Configuration', action = 'edit ~/.config/nvim/init.lua'},
        {icon = '  ', desc = 'Update Plugins', action = 'Lazy sync'}
      }
      dashboard.hide_statusline = 1
      dashboard.hide_tabline = 1
    end
  },
  {
    'ayu-theme/ayu-vim',
    config = function()
      vim.cmd[[colorscheme ayu]]
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = { theme = 'ayu' },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        }
      })
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup {
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
        },
        icons = {
          breadcrumb = '»', 
          separator = '➔', 
          group = '+',
        },
        window = {
          border = 'rounded',
          position = 'bottom',
          margin = { 1, 0, 1, 0 },
        },
      }
    end
  },
   {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]], -- You can change this shortcut
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1  -- Start preview automatically
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",       -- Required dependency
      "nvim-tree/nvim-web-devicons", -- Optional, for file icons
      "MunifTanjim/nui.nvim",        -- Required dependency for neo-tree
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,      -- Close Neo-tree if it's the last open window
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,        -- Show dotfiles by default
            hide_gitignored = true,       -- Hide Git ignored files
          },
        },
        window = {
          width = 30,                     -- Set the width of the neo-tree window
        },
        git_status = {
          enabled = true,                 -- Show git status in neo-tree
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- Customize Noice behavior for notifications, popups, etc.
        lsp = {
          progress = { enabled = true },
          hover = { enabled = true },
          signature = { enabled = false },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      })
    end,
  }
})

-- Creates banner for .cpp files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    -- Get the current date
    local date = os.date("%Y-%m-%d")
    -- Get the filename
    local filename = vim.fn.expand("%:t")

    -- Define the banner template
    local banner = string.format([[
/*****************************
Author: Ashwin Nair
Date: %s
Project name: %s
Summary: Enter summary here.
*****************************/
]], date, filename)

    -- Insert the banner at the top of the file
    vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(banner, "\n"))
  end,
})

-- Copy and paste from wez to other apps
vim.api.nvim_set_option("clipboard", "unnamed")

-- Custom command to open a floating terminal and send a notification
vim.api.nvim_create_user_command("ToggleTerminal", function()
  require("toggleterm").toggle()
  local path = vim.fn.getcwd()
  if pcall(require, "noice") then
    require("noice").notify("Opened terminal in " .. path, "info", { title = "Terminal" })
  else
    vim.notify("Opened terminal in " .. path, "info", { title = "Terminal" })
  end
end, {})

-- Ensure you have installed the necessary plugins by running :Lazy sync in Neovim
vim.api.nvim_create_user_command('OldFiles', function()
  require('telescope.builtin').oldfiles()
end, { desc = 'Show Recently Opened Files with Telescope' })

-- ToggleTerm setup for running C++ files in a floating terminal
local toggleterm = require("toggleterm.terminal").Terminal

function run_cpp_file()
  vim.cmd("w")  -- Save the file
  local compile_cmd = "g++ " .. vim.fn.expand("%") .. " -o " .. vim.fn.expand("%:r")
  vim.fn.system(compile_cmd)

  if vim.v.shell_error == 0 then
    local executable = vim.fn.expand("%:r")
    local cpp_terminal = toggleterm:new({
      cmd = executable,
      direction = "float",
      close_on_exit = false,
      hidden = true
    })
    cpp_terminal:toggle()
  else
    print("Compilation failed. Please check for errors.")
  end
end

-- Register which-key mappings
local wk = require("which-key")

wk.register({
  w = { ":w<CR>", "Save File" },
  q = { ":wq<CR>", "Save and Exit" },
  m = {
    name = "Markdown",
    o = { ":MarkdownPreview<CR>", "Open Markdown Preview" },
    t = { "<cmd>MarkdownPreviewToggle<CR>", "Toggle Markdown Preview" },
  },
  r = { ":w | !python3 %<CR>", "Run Python File" },
  c = { ":lua run_cpp_file()<CR>", "Run C++ File" },
  n = { ":w | !node %<CR>", "Run Node.js File" },
  d = { ":Dashboard<CR>", "Return to Dashboard" },
  e = { "<cmd>Neotree toggle<CR>", "Toggle Neo-tree" },
  t = { "<cmd>ToggleTerminal<CR>", "Open Terminal" }
}, { prefix = "<leader>" })

