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
  },{
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({
            -- Add your custom configuration here
            toggler = {
                line = 'gcc', -- Line comment toggle keymap
                block = 'gbc', -- Block comment toggle keymap
            },
            opleader = {
                line = 'gc', -- Line comment keymap
                block = 'gb', -- Block comment keymap
            },
            mappings = true, -- Enable default keybindings
            pre_hook = nil, -- Add pre-hook for integration with Treesitter or LSP
            post_hook = nil, -- Add post-hook if needed
        })
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
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require("lspconfig")
            
            -- Setup for Python (pyright) and C++ (clangd)
            lspconfig.pyright.setup({})
            lspconfig.clangd.setup({})
            
            -- Diagnostics configurations
            vim.diagnostic.config({
                virtual_text = true,  -- Display error messages inline
                signs = true,         -- Show error signs in the gutter
                update_in_insert = false,  -- Only update diagnostics when not in insert mode
            })
        end,
    },
   {
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                cpp = { 'cppcheck' },        -- Linter for C++
                python = { 'flake8' },       -- Linter for Python
            }
            -- Auto-lint on save
            vim.cmd([[
                autocmd BufWritePost *.cpp,*.py lua require('lint').try_lint()
            ]])
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
        routes = {
          -- Route to display error messages after compilation
          {
            filter = { event = "msg_show", kind = "error" },
            opts = {
              skip = false,
              title = "Compilation Error",
              icon = " ", -- Add an icon for visibility (optional)
              message = function(msg)
                return "Error: " .. msg -- Customize message format
              end,
            },
          },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
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

vim.api.nvim_create_user_command("WordCount", function()
    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()
    -- Get all lines in the buffer
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Initialize word count
    local word_count = 0

    -- Iterate through each line
    for _, line in ipairs(lines) do
        -- Skip empty or whitespace-only lines
        if vim.trim(line) ~= "" then
            -- Count words in the line
            local words = vim.fn.split(vim.trim(line), "\\s+")
            word_count = word_count + #words
        end
    end

    -- Display the word count using vim.notify
    vim.notify("Word Count: " .. word_count, vim.log.levels.INFO, { title = "Word Count" })
end, { desc = "Counts words in the current buffer and displays the result" })


-- Copy and paste from wez to other apps
vim.api.nvim_set_option("clipboard", "unnamed")

-- PDF Viewer
vim.api.nvim_create_user_command('ViewPDF', function()
  local file = vim.fn.expand('%:p')  -- Get the full file path
  if file:match('%.pdf$') then  -- Check if the file is a PDF
    -- Open the PDF with Skim
    vim.fn.system("open -a Skim " .. file)
  else
    print("Not a PDF file!")
  end
end, { desc = "View the current PDF file" })

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

function _G.close_current_terminal()
  local current_buf = vim.api.nvim_get_current_buf()
  -- Check if the current buffer is a terminal
  if vim.bo[current_buf].filetype == "toggleterm" then
    vim.cmd("bdelete!") -- Close the current terminal buffer
  else
    print("Not a terminal window")
  end
end


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

-- Automatically lint and clear diagnostics on save
vim.cmd([[
    autocmd BufWritePost *.cpp,*.py,*.md lua require('lint').try_lint()
    autocmd BufWritePost *.cpp,*.py,*.md lua vim.diagnostic.hide() -- Clears diagnostics after display
]])

-- Enable spell checking for specific file types
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" }, -- Add other file types as needed
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
    end,
})

-- Custom highlighting for spelling errors
vim.cmd([[
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=Red guibg=None guifg=Red
]])

-- Set color bar at :80 characters
vim.opt.colorcolumn = "80"   -- Set color bar at the 80th column
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=red]])   -- Customize the color

-- Set tab width to 4 spaces
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Ensure toggleterm.nvim is loaded
local Terminal = require("toggleterm.terminal").Terminal

-- Create a custom terminal instance with specified options
local mst_terminal = Terminal:new({
  direction = "vertical",
  size = 30, -- Adjust the width as needed
  on_open = function(term)
    -- Send 'mst' command to the terminal when it opens
    vim.api.nvim_feedkeys("mst\n", "n", false)
  end,
})

-- Function to toggle the custom terminal
function _G.open_right_terminal_with_mst()
  mst_terminal:toggle()
end

-- Function for Markdown -> PDF
local function markdown_to_pdf()
    local file_path = vim.fn.expand("%:p")
    if file_path == "" or not file_path:match("%.md$") then
        vim.notify("No Markdown file selected", vim.log.levels.WARN)
        return
    end

    local pdf_name = vim.fn.input("Enter PDF name (without .pdf extension): ") .. ".pdf"
    local pdf_path = vim.fn.expand("%:p:h") .. "/" .. pdf_name

    -- Run Pandoc with `wkhtmltopdf` as the PDF engine
    vim.fn.jobstart({"pandoc", file_path, "-t", "html5", "--pdf-engine=wkhtmltopdf", "-o", pdf_path}, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
        end,
        on_stderr = function(_, data)
            if data then
                -- Filter out title warnings
                local filtered_errors = {}
                for _, line in ipairs(data) do
                    if not line:match("requires a nonempty <title> element") then
                        table.insert(filtered_errors, line)
                    end
                end
                if #filtered_errors > 0 then
                    vim.notify("Pandoc Error: " .. table.concat(filtered_errors, "\n"), vim.log.levels.ERROR)
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify("PDF created: " .. pdf_path, vim.log.levels.INFO)
            else
                vim.notify("Error creating PDF", vim.log.levels.ERROR)
            end
        end,
    })
end

local noice = require("noice")

-- Function to notify about misspelled words
local function notify_spell_error()
    if vim.wo.spell then
        local line = vim.api.nvim_get_current_line()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local col = cursor_pos[2]
        local word = vim.fn.matchstr(line:sub(1, col + 1), "\\k*$")
            .. vim.fn.matchstr(line:sub(col + 2), "^\\k*")

        if word ~= "" and vim.fn.spellbadword(word)[1] ~= "" then
            noice.notify("Misspelled Word: " .. word, "warn", {
                title = "Spell Check",
            })
        end
    end
end

-- Call function on CursorHold for real-time updates
vim.api.nvim_create_autocmd("CursorHold", {
    callback = notify_spell_error,
})

local wk = require("which-key")

wk.register({
  w = { ":w<CR>", "Save File" },
  r = { ":w | !python3 %<CR>", "Run Python File" },
  c = { ":lua run_cpp_file()<CR>", "Run C++ File" },
  q = { ":wq<CR>", "Save and Exit" },
  v = { ":ViewPDF<CR>", "View PDF" },
  m = {
    name = "Markdown",
    o = { ":MarkdownPreview<CR>", "Open Markdown Preview" },
    t = { "<cmd>MarkdownPreviewToggle<CR>", "Toggle Markdown Preview" },
    c = { markdown_to_pdf, "Convert Markdown to PDF" },
    v = { view_pdf, "View PDF" }
  },
  n = { ":w | !node %<CR>", "Run Node.js File" },
  d = { ":Dashboard<CR>", "Return to Dashboard" },
  e = { "<cmd>Neotree toggle<CR>", "Toggle Neo-tree" },
  t = {
    name = "Terminal",
    t = { "<cmd>ToggleTerminal<CR>", "Open Terminal" },
    r = { "<cmd>lua open_right_terminal_with_mst()<CR>", "Open Split with Mistral" },
    c = { "<cmd>ToggleTermToggleAll<CR>", "Close All Terminals" },
    x = { "<cmd>lua close_current_terminal()<CR>", "Close Current Terminal" },
  },
  T = {
    name = "Todo",
    a = { "<cmd>TodoTrouble<cr>", "Show Todos in Trouble" },
    f = { "<cmd>TodoTelescope<cr>", "Find Todos" },
    n = { "<cmd>TodoNext<cr>", "Next Todo" },
    p = { "<cmd>TodoPrev<cr>", "Previous Todo" },
    t = { "<cmd>TodoToggle<cr>", "Toggle Todo Highlighting" },
  },
  W = {
    name = "Word Count",
    c = { ":WordCount<CR>", "Show Word Count" },
  },
  s = {
    name = "Spell Check", -- Spell-check-related commands
    t = { ":set spell!<CR>", "Toggle Spell Check" },
    n = { "]s", "Next Spelling Error" },
    p = { "[s", "Previous Spelling Error" },
    s = { "z=", "Suggestions for Word" },
    a = { "zg", "Add Word to Dictionary" },
    r = { "zw", "Remove Word from Dictionary" },
  },
}, { prefix = "<leader>" })

