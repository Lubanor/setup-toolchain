-- ~/.config/nvim/lua/plugins.lua

return {
  -- Colorscheme
  { 'folke/tokyonight.nvim', name = 'tokyonight', lazy = false, priority = 1000, opts = {} },
  -- Or if you prefer your old one and it's Lua compatible or you have a Lua port:
  -- { 'reedes/vim-colors-pencil' }, -- Note: vim-plug syntax, for lazy.nvim just the path

  -- Essential utility
  { 'nvim-lua/plenary.nvim', name = 'plenary', lazy = true },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons', lazy = true },

  -- Telescope (Fuzzy Finder)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x', -- Or latest stable
    dependencies = { 'plenary', 'nvim-web-devicons' },
    config = function()
      require('plugins.configs.telescope')
    end,
  },
  { -- Telescope fzf-native sorter for performance
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function() return vim.fn.executable 'make' == 1 end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- LSP Setup
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig', -- Optional: for easier reference
    event = { "BufReadPre", "BufNewFile" }, -- Load on buffer events
    dependencies = {
      { 'williamboman/mason.nvim', build = ":MasonUpdate" }, -- Automatically sets up mason
      'williamboman/mason-lspconfig.nvim',
      -- { 'j-hui/fidget.nvim', tag = 'legacy', opts = {}, enabled = false }, -- UI for LSP progress, consider nvim-notify or other alternatives
      -- For autocompletion, nvim-cmp is listed below
    },
    config = function()
      require('plugins.configs.lsp')
    end,
  },

  -- Autocompletion Engine (nvim-cmp)
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      { 'L3MON4D3/LuaSnip', dependencies = {"rafamadriz/friendly-snippets"}, build = "make install_jsregexp" }, -- Snippet engine + some snippets
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require('plugins.configs.cmp')
    end,
  },

  -- Treesitter for syntax highlighting and more
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('plugins.configs.treesitter')
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-web-devicons' },
    event = "VeryLazy", -- Load when everything else is done
    config = function()
      require('plugins.configs.lualine')
    end,
  },

  -- Indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- char = "▏",
      -- show_trailing_blankline_indent = false,
      -- show_current_context = true,
      -- show_current_context_start = true,
    },
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },

  -- Commenting
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    config = function()
      require('Comment').setup()
    end,
  },

  -- Which-key (shows available keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300 -- Time in ms to wait for a mapped sequence
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- For example:
      -- preset = "helix"
    }
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Surround (keep your vim-surround or use a Lua alternative)
  { 'tpope/vim-surround' },
  -- OR Lua alternative:
  -- {
  --   'kylechui/nvim-surround',
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-surround").setup({
  --       -- Configuration here, or leave empty to use defaults
  --     })
  --   end
  -- },

  -- File explorer (optional, if you want one like NERDTree or nvim-tree)
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   version = "*",
  --   dependencies = { 'nvim-web-devicons' },
  --   config = function() require('plugins.configs.nvimtree') end,
  -- },

  -- Dashboard/Start screen (alternative to vim-startify)
  {
    'goolord/alpha-nvim',
    -- event = "VimEnter", -- Load on VimEnter
    dependencies = { 'nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end,
    enabled = true, -- Set to false if you don't want a dashboard
  },

  -- Consider other plugins from your old config if you still need them:
  -- 'tpope/vim-repeat' -- often works well without explicit config.
  -- 'christoomey/vim-system-copy' -- Check if `vim.opt.clipboard = 'unnamedplus'` is sufficient.

  -- Plugins from your old config that are replaced:
  -- 'Yggdroot/indentLine' -> indent-blankline.nvim
  -- 'vim-airline/vim-airline' -> lualine.nvim
  -- 'ervandew/supertab' -> nvim-cmp
  -- 'ncm2/*' -> nvim-cmp
  -- 'roxma/nvim-yarp' -- Dependency for ncm2, likely not needed
  -- 'scrooloose/syntastic' -> LSP diagnostics
  -- 'neovim/nvim-lspconfig' & 'williamboman/nvim-lsp-installer' -> Handled by the new lspconfig and mason entries
  -- 'klen/python-mode' -> Python LSP (pyright or jedi_language_server via Mason)
}
