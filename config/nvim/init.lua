require("danejeon")

-- Plugin Manager Setup
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Lazy load telescope on command
    use {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        }
    }

    -- Lazy load Treesitter for programming files only (not LaTeX)
    use {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    disable = { "latex" } -- disable LaTeX for performance
                }
            }
        end
    }

    -- Lazy load VimTeX
    use {
        'lervag/vimtex',
        ft = { 'tex', 'plaintex' }
    }

    -- Lazy load UltiSnips
    use {
        'SirVer/ultisnips',
        ft = 'tex',
        requires = 'honza/vim-snippets'
    }

    use 'tpope/vim-dispatch'
end)

-- General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 1000 
vim.opt.shadafile = ''

-- VimTeX Config (Optimized)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.backup = false
    vim.bo.indentexpr = "" 
  end,
})
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_indent_enabled = 0
vim.g.vimtex_complete_enabled = 0
vim.g.vimtex_syntax_enabled = 0 
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_fold_enabled = 0
vim.g.vimtex_imaps_enabled = 0
vim.g.vimtex_quickfix_enabled = 0
vim.g.vimtex_echo_enabled = 0
vim.g.vimtex_matchparen_enabled = 0
vim.g.vimtex_motion_enabled = 0
vim.g.vimtex_toc_enabled = 0
vim.g.vimtex_compiler_latexmk = {
    backend = 'nvim',
    build_dir = '',
    callback = 0,  
    continuous = 0,
    executable = 'latexmk',
    options = { '-pdf', '-shell-escape', '-file-line-error', '-interaction=nonstopmode', '-synctex=1', '-silent' },
}
vim.g.tex_flavor = 'latex'
vim.g.python3_host_prog = '/Users/danejeon/anaconda3/bin/python3'
vim.g.tex_fast = 'bMpr'

-- Remove indentexpr for TeX (avoid delay)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.bo.indentexpr = ""
    end,
})

-- UltiSnips Config (lightweight)
vim.g.UltiSnipsSnippetDirectories = { '~/.config/nvim/my_snippets' }
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'

-- Telescope Config
local telescope = require('telescope')
local actions = require('telescope.actions')
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
            },
            n = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default + actions.center,
            }
        }
    },
    pickers = { find_files = { theme = "dropdown" } },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
telescope.load_extension('fzf')

-- Spell check
-- vim.api.nvim_create_autocmd("BufEnter", {
--    callback = function()
--        vim.opt_local.spell = true
--        vim.opt_local.spelllang = "en_us"
--    end
-- })

-- Keymap for spell correction
vim.api.nvim_set_keymap('i', '<C-l>', '<C-g>u<Esc>[s1z=]a<C-g>u', { noremap = true, silent = true })

-- Welcome message
print([[
         O_      __)(
       ,'  .   (_"..
      :      :    /|
      |      |   ((|_  ,-.
      ; -   /:  ,'  :(( -\
     /    -'  : ____ \\\-:
    _\__   ____|___  \____|_
   ;    |:|        '-      :
  :_____|:|__________________:
  ;     |:|                  :
 :      |:|                   :
 ;______ '___________________:
:                              :
|______________________________|
 ---.--------------------.---'
     |____________________|
     |                    |
     |____________________|
     |                    |
   _\|_\|_\/(__\__)\__\//_|(_

Welcome DANE JEON, our rising mathematician!
]])
