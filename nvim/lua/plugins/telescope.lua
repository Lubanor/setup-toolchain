-- ~/.config/nvim/lua/plugins/telescope.lua
local actions = require 'telescope.actions'

require('telescope').setup {
  defaults = {
    prompt_prefix = "  ", -- Nerd Font icon for search
    selection_caret = " ", -- Nerd Font icon for selection
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
      },
      n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
      },
    },
    sorting_strategy = "ascending",
    layout_strategy = "horizontal", -- or 'vertical', 'flex'
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.45,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    vimgrep_arguments = {
      "rg", -- Use ripgrep
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim", -- Useful for C/C++
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      -- theme = "dropdown", -- Example of theming a specific picker
    },
    live_grep = {
      -- theme = "dropdown",
    },
    buffers = {
      -- theme = "dropdown",
    },
    help_tags = {
      -- theme = "dropdown",
    },
    -- You can configure other pickers here
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case", "respect_case"
    },
    -- other extensions:
    -- ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
pcall(require('telescope').load_extension, 'fzf')
-- pcall(require('telescope').load_extension, 'ui-select') -- if you want to use it

-- Keymaps for Telescope (we'll move these to keymaps.lua later)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Find Old Files (History)' })
vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find, {desc = "Fuzzy find in current buffer"})
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = 'Fuzzy find in current buffer (dropdown)' })
