-- ~/.config/nvim/init.lua

-- Set <space> as the leader key
-- Must be set before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
-- It will load plugin specifications from lua/plugins.lua (or lua/plugins/init.lua if you prefer that name)
require('lazy').setup(require('plugins'), {
  -- Optional: configure lazy.nvim options here
  install = {
    colorscheme = { "tokyonight", "habamax" }, -- Try to load one of these first
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  checker = {
    enabled = true, -- Check for plugin updates
    notify = false, -- Don't notify on new commits, set to true if you want notifications
  },
  change_detection = {
    notify = false, -- Don't notify on config changes, set to true if you want notifications
  },
  performance = {
    rtp = {
      -- Use a custom path to speed up startup.
      -- disabled_plugins = { -- Consider disabling plugins you don't always need
      --   "gzip",
      --   "matchit",
      --   "matchparen",
      --   "netrwPlugin",
      --   "tarPlugin",
      --   "tohtml",
      --   "tutor",
      --   "zipPlugin",
      -- },
    },
  },
})

-- Load core configurations AFTER plugins are set up by lazy.nvim
-- as some options might depend on plugins being available (though less common)
-- or plugins might set options themselves.
-- Typically, options can be loaded before or after, but keymaps often depend on plugins.
require('core.options')
require('core.keymaps')
require('core.autocmds') -- Ensure this file exists or comment out

-- Set colorscheme (lazy.nvim might have already set one from the 'install' table)
-- This ensures your preferred one is set if available.
local status_ok, _ = pcall(vim.cmd.colorscheme, "tokyonight")
if not status_ok then
  pcall(vim.cmd.colorscheme, "habamax") -- Fallback colorscheme
end

print("Neovim configured!")
