-- ~/.config/nvim/lua/core/options.lua
local opt = vim.opt -- for conciseness

opt.nocompatible = true
opt.shell = '/bin/sh' -- Your preference
opt.history = 1000
opt.autoread = true
opt.autochdir = false -- I'd recommend against autochdir, can be confusing. Use a fuzzy finder to navigate.

-- UI
opt.number = true
opt.relativenumber = false -- Set to true if you prefer
opt.cursorline = true
-- opt.cursorcolumn = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true -- Break lines at 'breakat' characters
opt.showbreak = '↪ ' -- Character to show for wrapped lines
opt.list = true -- Show invisible characters
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '⟩', precedes = '⟨' }
opt.termguicolors = true
opt.laststatus = 3 -- Global statusline (alternative to vim-airline)
opt.showcmd = true
opt.cmdheight = 1
opt.ruler = true
opt.title = true -- Set terminal title
opt.hidden = true -- Allow hiding buffers without saving

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true -- Maintain indent for wrapped lines
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'
opt.gdefault = true -- Assume 'g' flag for :s by default
opt.completeopt = {'menuone', 'noselect', 'noinsert'} -- Completion options

-- Performance & Behavior
opt.lazyredraw = true
opt.updatetime = 250 -- Faster updates for CursorHold events (e.g., git signs, LSP hover)
opt.timeoutlen = 500 -- Time in ms to wait for a mapped sequence to complete
opt.ttimeoutlen = 10 -- Time in ms to wait for a key code sequence
opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.mouse = 'a' -- Enable mouse support
opt.confirm = true -- Ask for confirmation when :q and changes exist

-- Folding
opt.foldmethod = 'indent' -- Or 'expr' with nvim-ufo, 'manual', 'marker'
opt.foldlevel = 99       -- Start with all folds open
opt.foldenable = true
opt.foldcolumn = '0' -- '0' is default, '1' shows a column, 'auto:1-9'

-- Files and Backups (Your preferences)
opt.ffs = {'unix', 'dos', 'mac'}
-- opt.backup = true
-- opt.backupdir = vim.fn.stdpath('data') .. '/backup//'
-- opt.directory = vim.fn.stdpath('data') .. '/swap//'
-- opt.undofile = true
-- opt.undodir = vim.fn.stdpath('data') .. '/undo//'
-- vim.fn.mkdir(vim.fn.stdpath('data') .. '/backup', 'p')
-- vim.fn.mkdir(vim.fn.stdpath('data') .. '/swap', 'p')
-- vim.fn.mkdir(vim.fn.stdpath('data') .. '/undo', 'p')

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.wildmenu = true
opt.wildmode = {'longest:full', 'full'}

-- Don't pass messages to |ins-completion-menu|
opt.shortmess:append 'c'
-- Always show the signcolumn, otherwise it would shift the text
opt.signcolumn = 'yes:1' -- Show signcolumn, reserve 1 column

-- Set python provider if needed (though LSP is preferred for Python dev)
-- vim.g.python3_host_prog = '/path/to/your/python3' -- if Neovim can't find it
