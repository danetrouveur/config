-- Require necessary modules
require("danejeon")

-- Packer plugin manager installation
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use 'nvim-treesitter/nvim-treesitter'
    use 'lervag/vimtex'
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'
    use 'tpope/vim-dispatch'
end)

-- Function to check if Zathura is running
local function is_zathura_running()
    local handle = io.popen("pgrep -x zathura")
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

-- VimTeX configuration
vim.g.vimtex_view_general_viewer = 'zathura'

-- Override the viewer command to include a check for Zathura
vim.g.vimtex_view_zathura = function()
    if not is_zathura_running() then
        os.execute('zathura ' .. vim.fn.shellescape(vim.fn.expand('%:p')) .. ' &')
    else
        -- If Zathura is already running, you can refresh it or do nothing
        -- os.execute('pkill -HUP zathura') -- This will reload Zathura, if desired
    end
end

vim.g.vimtex_compiler_method = 'latexmk'
vim.g.tex_flavor = 'latex'
vim.g.python3_host_prog = '/Users/danejeon/anaconda3/bin/python3'
vim.g.vimtex_quickfix_mode = 0
vim.o.conceallevel = 1
vim.g.tex_conceal = 'abdmg'

-- Vimtex compiler settings
vim.g.vimtex_compiler_latexmk = {
    build_dir = '',
    callback = 1,
    continuous = 1,
    executable = 'latexmk',
    hooks = {},
    options = {
        '-pdf',
        '-shell-escape',
        '-file-line-error',
        '-interaction=nonstopmode',
        '-synctex=1',
    },
}

-- Optional: Auto compile on save (may be redundant with continuous mode)
vim.cmd [[
  augroup LaTeX
    autocmd!
    autocmd BufWritePost *.tex VimtexCompile
  augroup END
]]

-- Additional settings
vim.opt.relativenumber = true
vim.opt.number = true

-- Telescope configuration
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        path_display = { "smart" },
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default + actions.center,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default + actions.center,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
            },
        },
    },
    pickers = {
        find_files = {
            theme = "dropdown",
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}

require('telescope').load_extension('fzf')

-- Spell check
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt_local.spell = true
  end
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt_local.spelllang = "en_us"
  end
})
vim.api.nvim_set_keymap('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u', { noremap = true, silent = true })

-- Lecture note update
local function new_lecture_note()
	-- Prompt for the lecture number or name
	local filename = vim.fn.input('Enter the filename (without .tex): ')
	local fullpath = filename .. '.tex'
	
	-- Read the template context
	local template_path = '/Users/danejeon/Documents/notes/template/default.tex'
	local template_file = io.open(template_path, "r")
	local template_content = template_file:read("*a")
	template_file:close()

	-- Create the new file with the template
	local new_file = io.open(fullpath, "w")
	new_file:write(template_content)
	new_file:close()

	-- Update the master file at a specific location
	local master_path = 'default.tex'
	local master_file = io.open(master_path, "r")
	local master_content = master_file:read("*a")
	master_file:close()

	-- Define the insertion marker
	local insertion_marker = '% INSERT_HERE'
	local new_input_command = '\\input{'.. fullpath ..'}\\n'

	-- Insert the new input command
	master_content = master_content:gsub(insertion_marker, insertion_marker .. new_input_command)

	-- Write the updated content back to the master file
	master_file = io.open(master_path, "w")
	master_file:write(master_content)
	master_file:close()

	print('Created '.. fullpath..' and updated master.tex')
end

-- Map the function to a key
vim.api.nvim_set_keymap('n', '<Leader>n', ':lua new_lecture_note()<CR>', { noremap = true, silent = true })

-- Welcome message
print([[
         O_      __)(
       ,'  `.   (_".`.
      :      :    /|`
      |      |   ((|_  ,-.
      ; -   /:  ,'  `:(( -\
     /    -'  `: ____ \\\-:
    _\__   ____|___  \____|_
   ;    |:|        '-`      :
  :_____|:|__________________:
  ;     |:|                  :
 :      |:|                   :
 ;______ `'___________________:
:                              :
|______________________________|
 `---.--------------------.---'
     |____________________|
     |                    |
     |____________________|
     |                    |
   _\|_\|_\/(__\__)\__\//_|(_

Welcome DANE JEON, our rising mathematician!
]])

vim.g.UltiSnipsSnippetDirectories = {'~/.config/nvim/my_snippets'}

-- Set UltiSnips as the default snippet engine
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'

