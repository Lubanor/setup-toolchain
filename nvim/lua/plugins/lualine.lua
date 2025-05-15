-- ~/.config/nvim/lua/plugins/configs/lualine.lua
local function get_lsp_client_names()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  return "[" .. table.concat(client_names, ", ") .. "]"
end

require('lualine').setup({
  options = {
    icons_enabled = vim.g.have_nerd_font, -- Check if you set this global for nerd font detection
    theme = 'tokyonight', -- Or 'auto', or any other lualine theme
    component_separators = { left = '', right = ''}, -- Nerd Font separators
    section_separators = { left = '', right = ''},   -- Nerd Font separators
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true, -- Make statusline global
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
      {'diagnostics', sources = {"nvim_diagnostic"}, symbols = {error = " ", warn = " ", info = " ", hint = " "}}
    },
    lualine_c = {
        {'filename', path = 1}, -- 0 = just filename, 1 = relative path, 2 = absolute path
        { get_lsp_client_names } -- Show active LSP servers
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {'nvim-tree', 'toggleterm', 'quickfix'} -- Add extensions you use
})
