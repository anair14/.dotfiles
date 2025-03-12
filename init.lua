-- Lazy.nvim setup
local lazypath = vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--single-branch', 'https://github.com/folke/lazy.nvim', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.number = true
vim.opt.relativenumber = true

-- Set leader key to space
vim.g.mapleader = " "

-- Lazy.nvim setup
require("lazy").setup({
  -- Dashboard Plugin Setup
   {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig", -- LSP for better suggestions
    "jose-elias-alvarez/null-ls.nvim", -- For additional formatting & linting
    "nvim-lua/plenary.nvim", -- Required for null-ls
  },
  config = function()
    -- Setup nvim-cmp for autocompletion
    local cmp = require("cmp")
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
      }),
      sources = {
        { name = "nvim_lsp" }, -- Use LSP as the source
        { name = "buffer" },   -- Autocomplete words in the file
        { name = "path" },     -- Autocomplete paths
      },
    })

    -- Setup LSP for JavaScript (tsserver)
    local lspconfig = require("lspconfig")
    lspconfig.tsserver.setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- Setup null-ls for linting & formatting (ESLint, Prettier)
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier, -- Auto-format JavaScript files
        null_ls.builtins.diagnostics.eslint_d, -- Lint JavaScript using ESLint
      },
    })
  end,
}, {
    "glepnir/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = {
					"                                                                                                    ",
					"                                                                                                    ",
					"                                                                                                    ",
					"                         .^!^                                           .!~:                        ",
					"                    ^!JPB&B7.                                            !&&BPJ!:                   ",
					"                ^?P#@@@@@G.                   :       :                   ~@@@@@&B5!:               ",
					"             ^JB@@@@@@@@@7                   .#~     ?G                   .&@@@@@@@@&G?:            ",
					"          .7G@@@@@@@@@@@@#!                  7@&^   ~@@^                 .5@@@@@@@@@@@@@G7.         ",
					"        .?#@@@@@@@@@@@@@@@@BY!^.             B@@&BBB&@@Y              :~Y#@@@@@@@@@@@@@@@@#?.       ",
					"       !#@@@@@@@@@@@@@@@@@@@@@@#G5Y?!~^:..  ~@@@@@@@@@@#.   ..::^!7J5B&@@@@@@@@@@@@@@@@@@@@@#!      ",
					"     .5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&##B#@@@@@@@@@@@BBBB##&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y     ",
					"    :B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5    ",
					"   .B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@J   ",
					"   5@&#BGGPPPPPGGB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGP555PPGBB#&#:  ",
					"   ^:.            .^!YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&57^.            .:^.  ",
					"                       ~G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5:                      ",
					"                         P@@@#BGGGGB#@@@@@@@@@@@@@@@@@@@@@@@@@#BP5555PG#@@@P                        ",
					"                         :J!:.      .^!JG&@@@@@@@@@@@@@@@@#57^.        .:!5~                        ",
					"                                         :?G@@@@@@@@@@@@P!.                                         ",
					"                                            ~5@@@@@@@@5^                                            ",
					"                                              ^P@@@@G^                                              ",
					"                                                !#@?                                                ",
					"                                                 :^                                                 ",
					"                                                                                                    ",
					"                                                                                                    ",
					"                                                                                                    ",

				},
				footer = {},
				packages = { enable = false },
				project = {
					enable = false,
				},
				mru = {
					limit = 5,
				},
	shortcut = {
    { desc = " Update", group = "@property", action = "Lazy update", key = "u" },
    {
        icon = " ",
        desc = "Files",
        group = "@property",
        action = ":FzfFiles<CR>",
        key = "f",
    },
    {
        desc = " Grep",
        group = "@property",
        action = ":FzfRg<CR>",
        key = "g",
    },
    {
        desc = " Exit",
        group = "@property",
        action = "qa",
        key = "q",
    },
},
			},
		})
	end,
  }, {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup({
                -- configuration options
                auto_update = true,   -- Automatically update presence
                neovim_image_text = "The One True Text Editor",  -- Text displayed for Neovim
                main_image = "file",  -- Main image used for RPC (can use other sources like 'file', 'text', etc.)
                large_image_text = "neovim",
                edit_mode = "false",
                enable_line_number = true,
                client_id = "1330968227001532560",  -- You'll need to create a Discord application to get this ID
                log_level = "info",    -- Log level for RPC updates
                editing_text = "Editing %s",  -- Shows the file you're editing
                file_explorer_text = "Browsing %s",
                reading_text = "Reading %s",
                plugin_manager_text = "Managing Plugins",
                line_number_text = "Line %s out of %s"
            })
        end
    },{
  "christoomey/vim-tmux-navigator",
  lazy = false
},
  {
  "junegunn/fzf.vim",
  dependencies = {
    "junegunn/fzf",
    build = ":call fzf#install()",
  },
  config = function()
    -- Basic FZF configuration
    vim.g.fzf_layout = {
      window = {
        width = 0.9,
        height = 0.9,
        border = 'rounded'
      }
    }

    -- Custom colors to match your theme
    vim.cmd([[
      let g:fzf_colors = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment']
      \ }
    ]])
  end
    },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = { theme = 'auto' },
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
    "morhetz/gruvbox",
    config = function()
    end
  },{ 'dasupradyumna/midnight.nvim', 
       lazy = false,
       priority = 1000 }
  ,{
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup()
        end
    },
  {
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
            mappings = {
                basic = true,
                extra = true
            }, -- Enable default keybindings
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
        direction = "vertical",
        float_opts = {
          border = "curved",
        },
      })
    end
  },
 {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install', -- Ensures dependencies are installed
        ft = 'markdown',                -- Lazy load for markdown files
        config = function()
            vim.g.mkdp_auto_start = 0   -- Prevent auto-start
            vim.g.mkdp_auto_close = 1   -- Close preview on buffer switch
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
            require("lspconfig").pyright.setup({}) -- Example: Python LSP
            require("lspconfig").tsserver.setup({}) -- Example: TypeScript LSP 
            -- Setup for Python (pyright) and C++ (clangd)
            lspconfig.pyright.setup({})
            lspconfig.clangd.setup({})
            lspconfig.gopls.setup({})
            
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
            go = { 'golangcilint' },     -- Linter for Go
            java = { 'checkstyle' },     -- Linter for Java
        }
        -- Auto-lint on save
        vim.cmd([[
            autocmd BufWritePost *.cpp,*.py,*.go,*.java lua require('lint').try_lint()
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
  pattern = { "*.cpp", "*.py", "*.md", "*.go" },
  callback = function()
    local date = os.date("%Y-%m-%d")
    local filename = vim.fn.expand("%:t")
    local banner

    if vim.bo.filetype == "cpp" then
      -- C++ file banner
      banner = string.format([[
/*****************************
Author: Ashwin Nair
Date: %s
Project name: %s
Summary: Enter summary here.
*****************************/
]], date, filename)

    elseif vim.bo.filetype == "python" then
      -- Python file banner
      banner = string.format([[
"""
Author: Ashwin Nair
Date: %s
Project name: %s
Summary: Enter summary here.
"""
]], date, filename)

    elseif vim.bo.filetype == "markdown" then
      -- Markdown file banner
      banner = string.format([[
<!--
Author: Ashwin Nair
Date: %s
Project name: %s
Summary: Enter summary here.
-->
]], date, filename)

   elseif vim.bo.filetype == "go" then
    -- Go file banner
    banner = string.format([[
/*****************************
Author: Ashwin Nair
Date: %s
Project name: %s
Package: %s
Summary: Enter summary here.
*****************************/

package %s
]], date, filename, vim.fn.expand('%:t:r'), vim.fn.expand('%:t:r'))
end

    -- Insert the banner at the top of the file
    if banner then
      vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(banner, "\n"))
    end
  end,
})


-- Set colorscheme to gruvbox
vim.cmd.colorscheme 'midnight'

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

-- Function to switch theme and notify with Noice
local function set_theme(mode)
  if mode == "dark" then
    vim.opt.background = "dark"
    require("noice").notify("Switched to Gruvbox Dark Mode", "info")
  elseif mode == "light" then
    vim.opt.background = "light"
    require("noice").notify("Switched to Gruvbox Light Mode", "info")
  end
end

-- Function to scan the current file and get suggestions from DeepSeek
local function scan_with_deepseek()
    local file_path = vim.fn.expand('%:p') -- Get the full file path
    if file_path == "" or vim.bo.filetype == "" then
        vim.notify("No file selected!", vim.log.levels.WARN)
        return
    end

    local deepseek_cmd = "ollama run nezahatkorkmaz/deepseek-v3 < " .. file_path

    -- Open ToggleTerm and run DeepSeek command
    require("toggleterm.terminal").Terminal:new({
        cmd = deepseek_cmd,
        direction = "vertical", -- Opens in a horizontal split (you can change to "float" or "vertical")
        close_on_exit = false,    -- Keeps the terminal open after execution
    }):toggle()
end

-- Function to run Go files
function RunGoFile()
    local filepath = vim.fn.expand('%:p') -- Get the full path of the current file
    if vim.bo.filetype == "go" then
        vim.cmd("!go run " .. filepath)
    else
        print("Not a Go file!")
    end
end

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

-- Basically sets comment.nvim and which-key to silent (they spam me :( ).
vim.notify = function(msg, ...)
    if msg:match("which-key") or msg:match("Comment.nvim") then
        return
    end
    require("notify")(msg, ...)
end

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

local function run_java()
  local file = vim.fn.expand("%:p") -- Full path of the current file
  local class_name = vim.fn.expand("%:t:r") -- Extract class name without extension
  local compile_run_cmd = "javac " .. file .. " && java " .. class_name
  -- If using tmux instead of toggleterm
  os.execute("tmux new-session -d '" .. compile_run_cmd .. "'")
  os.execute("tmux attach-session -d")
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

-- Runs the TODO file in a toggle term window
local function run_specific_cpp_file()
    local filepath = "/Users/ashwinnair/Dropbox/LoyolaCoursework/Fall2024/COSC-A211/final_project/main.cpp" 
    local compile_cmd = "g++ -std=c++17 -Wall -o temp_exec " .. filepath
    local run_cmd = "./temp_exec"

    vim.notify("Opened ToDo List!")
    -- Open a floating terminal and execute the commands
    require("toggleterm.terminal").Terminal:new({
        cmd = compile_cmd .. " && " .. run_cmd,
        direction = "float",
        close_on_exit = false, -- Keeps the terminal open after running
    }):toggle()
end

-- Run Tmux Session saving protocol
local function save_tmux_session()
  vim.fn.system("tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh")
  require("noice").notify("Tmux session saved successfully!", {
    title = "Tmux Session",
    icon = "💾",
    level = "success",
    timeout = 2000,
  })
end

-- Runs java file.
local Terminal = require("toggleterm.terminal").Terminal

local function run_java()
  local file = vim.fn.expand("%:p") -- Get the full path of the current file
  local filename_without_ext = vim.fn.expand("%:t:r") -- Get filename without extension
  local compile_run_cmd = "javac " .. file .. " && java " .. filename_without_ext

  local java_terminal = Terminal:new({
    cmd = compile_run_cmd,
    direction = "float", -- or "horizontal", "vertical"
    close_on_exit = false
  })

  java_terminal:toggle()
end

-- ColorSet
-- For Neo-tree
vim.cmd [[
  highlight NeoTreeNormal guifg=#D7AF00
  highlight NeoTreeNormalNC guifg=#D7AF00
  highlight NeoTreeRootName guifg=#D7AF00 gui=bold
  highlight NeoTreeFileName guifg=#D7AF00
  highlight NeoTreeFileIcon guifg=#D7AF00
  highlight NeoTreeFileNameOpened guifg=#D7AF00 gui=bold
  highlight NeoTreeIndentMarker guifg=#D7AF00
  highlight NeoTreeGitAdded guifg=#D7AF00
  highlight NeoTreeGitModified guifg=#D7AF00
  highlight NeoTreeGitUntracked guifg=#D7AF00
  highlight NeoTreeDirectoryName guifg=#D7AF00
  highlight NeoTreeDirectoryIcon guifg=#D7AF00
]]

-- For Noice notifications
vim.cmd [[
  highlight NoicePopup guibg=#333333 guifg=#D7AF00
  highlight NoicePopupBorder guifg=#D7AF00
  highlight NoicePopupTitle guifg=#D7AF00
  highlight NoiceCmdline guifg=#D7AF00
  highlight NoiceCmdlineIcon guifg=#D7AF00
  highlight NoiceCmdlinePopup guibg=#333333 guifg=#D7AF00
  highlight NoiceCmdlinePopupBorder guifg=#D7AF00
  highlight NoiceCmdlinePrompt guifg=#D7AF00
  highlight NoiceConfirmBorder guifg=#D7AF00
  highlight NoiceFormatTitle guifg=#D7AF00 gui=bold
  highlight NoiceFormatProgressDone guibg=#D7AF00 guifg=#000000
  highlight NoiceFormatProgressTodo guibg=#333333 guifg=#D7AF00
]]

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fzf",
  callback = function()
    -- Make FZF window more prominent
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    -- Hide statusline in fzf buffer
    vim.opt_local.laststatus = 0
    -- Return to normal laststatus after closing fzf
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = 0,
      callback = function()
        vim.opt_local.laststatus = 2
      end
    })
  end
})

-- Custom highlighting for spelling errors
vim.cmd([[
highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=Red guibg=None guifg=Red
]])

-- Set color bar at :80 characters
vim.opt.colorcolumn = "80"   -- Set color bar at the 80th column
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=yellow]])   -- Customize the color

-- Set tab width to 4 spaces
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Autocomplete polishing?
vim.opt.pumblend = 10 -- 0 to 100 for transparency
vim.opt.winblend = 10  -- Make floating windows more transparent

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

    -- Pandoc command with xelatex for font customization
    local command = {
        "pandoc", file_path,
        "--pdf-engine=xelatex",
        "-o", pdf_path,
        "-V", "mainfont=Times New Roman",
        "-V", "fontsize=12pt"
    }

    vim.fn.jobstart(command, {
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

-- Define a custom command for toggling Markdown preview
vim.api.nvim_create_user_command('MarkdownPreviewToggle', function()
    vim.cmd("MarkdownPreviewToggle") -- Use the plugin's built-in toggle
end, { desc = "Toggle Markdown Preview" })

-- Call function on CursorHold for real-time updates
vim.api.nvim_create_autocmd("CursorHold", {
    callback = notify_spell_error,
})

local wk = require("which-key")

wk.register({
  w = { ":w<CR>", "Save File" },
  r = { 
        name = "Run",
        p = { ":w | !python3 %<CR>", "Run Python File" },
        c = { ":lua run_cpp_file()<CR>", "Run C++ File" },
        n = { ":w | !node %<CR>", "Run Node.js File" },
        t = { run_specific_cpp_file, "Run ToDo in Fall 2024" },
        g = { ":lua RunGoFile()<CR>", "Run Go File" },
        j = { run_java, "Run Java File" },
        f = { "<cmd>lua require'cmp'.complete()<CR>", "Trigger Autocomplete" }, -- Autocomplete Trigger
    },
  q = { ":wq<CR>", "Save and Exit" },
  v = { ":ViewPDF<CR>", "View PDF" },
  m = {
    name = "Markdown",
    o = { ":MarkdownPreview<CR>", "Open Markdown Preview" },
    t = { "<cmd>MarkdownPreviewToggle<CR>", "Toggle Markdown Preview" },
    c = { markdown_to_pdf, "Convert Markdown to PDF" },
    v = { view_pdf, "View PDF" }
  },
  n = { },
  d = { ":Dashboard<CR>", "Return to Dashboard" },
  e = { "<cmd>Neotree toggle<CR>", "Toggle Neo-tree" },
  t = {
    name = "Terminal",
    t = { "<cmd>ToggleTerminal<CR>", "Open Terminal" },
    r = { "<cmd>lua open_right_terminal_with_mst()<CR>", "Open Split with Mistral" },
    c = { "<cmd>ToggleTermToggleAll<CR>", "Close All Terminals" },
    x = { "<cmd>lua close_current_terminal()<CR>", "Close Current Terminal" },
    d = { scan_with_deepseek, "Scan with Deepseek" }
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
  f = {
    name = "Find (FZF)",
    f = { ":Files<CR>", "Find files" },
    g = { ":Rg<CR>", "Find text" },
    b = { ":Buffers<CR>", "Find buffers" },
    h = { ":History<CR>", "Find history" },
    c = { ":Commits<CR>", "Find commits" },
    l = { ":BLines<CR>", "Find in current buffer" },
    m = { ":Maps<CR>", "Find keymaps" },
    w = { ":Windows<CR>", "Find windows" },
    t = { ":Tags<CR>", "Find tags" },
    r = { ":OldFiles<CR>", "Find Recent Files" },
    ["/"] = { ":History/<CR>", "Find search history" },
    ["'"] = { ":Marks<CR>", "Find marks" }
  },
  l = {
    name = "Theme",
    d = { function() set_theme("dark") end, "Switch to Dark Mode" },
    l = { function() set_theme("light") end, "Switch to Light Mode" }
  },
  u = {
    name = "TMUX",
    r = { ":silent !tmux source ~/.tmux.conf<CR>", "Reload tmux config" },
    s = { ":silent !tmux new-session -s mysession<CR>", "Start new session" },
    a = { ":silent !tmux attach-session -t mysession<CR>", "Attach to session" },
    k = { ":!tmux kill-session -t mysession<CR>", "Kill session" },
    v = { ":silent !tmux split-window -v<CR>", "Vertical Split" },
    h = { ":silent !tmux split-window -h<CR>", "Horizontal Split" },
    e = { function() save_tmux_session() end, "Save Tmux Session" },
    n = { ":!tmux new-window<CR>", "New window" },
    p = { ":!tmux previous-window<CR>", "Previous window" },
    x = { ":!tmux next-window<CR>", "Next window" },
    d = { ":!tmux detach<CR>", "Detach session" },
    l = { ":!tmux list-sessions<CR>", "List sessions" },
  },
  g = {
    name = "Git",  -- Group name for git-related commands
    a = {
      function()
        vim.cmd(":!git add .")
        noice.notify({
          msg = "Changes staged with Git Add",
          level = "info",
          timeout = 2000,  -- Duration in ms
        })
      end,
      "Git Add"
    },  -- Git add command with noice notification

    c = {
      function()
        local commit_msg = vim.fn.input("Commit Message: ")  -- Prompt for commit message
        if commit_msg and commit_msg ~= "" then
          vim.cmd(":!git commit -m '" .. commit_msg .. "'")  -- Use the provided commit message
          noice.notify({
            msg = "Git Commit Started",
            level = "info",
            timeout = 2000,  -- Duration in ms
          })
        else
          noice.notify({
            msg = "Commit message is empty!",
            level = "warn",
            timeout = 2000,
          })
        end
      end,
      "Git Commit"
    },  -- Git commit command with noice notification
  }
}, { prefix = "<leader>" })
