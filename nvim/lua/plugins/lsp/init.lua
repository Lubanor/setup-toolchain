-- ~/.config/nvim/lua/plugins/lsp/init.lua
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp') -- For capabilities

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any ofthe below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after a language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- Handled by nvim-cmp

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts) -- Changed from <space>k
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts) -- Format

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Setup mason-lspconfig to use the on_attach function and capabilities
-- This will ensure that mason automatically sets up LSPs with our settings
mason_lspconfig.setup {
  ensure_installed = {
    'clangd',
    'lua_ls', -- For Lua development (configuring Neovim itself)
    'pyright', -- For Python
    -- Add other LSPs you need: 'bashls', 'dockerls', 'jsonls', 'yamlls', 'gopls', 'rust_analyzer', etc.
  },
  handlers = {
    -- Default handler function
    function(server_name)
      lspconfig[server_name].setup {
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
         -- You can add server-specific settings here if needed
         -- For clangd, it usually finds compile_commands.json automatically
         -- If not, you might need to specify command or root_dir logic
      }
    end,

    -- Example of custom setup for a specific server if needed
    ['clangd'] = function()
      lspconfig.clangd.setup {
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        cmd = {
          "clangd",
          "--background-index",
          "--pch-storage=memory",
          "--clang-tidy", -- Enable clang-tidy diagnostics
          "--completion-style=detailed",
          "--header-insertion=iwyu", -- Or 'never' or 'include-what-you-use'
          -- Add other clangd flags if needed
        },
        filetypes = {"c", "cpp", "objc", "objcpp", "cuda", "proto"},
        -- Clangd will search for compile_commands.json or compile_flags.txt
        -- For ESP-IDF, make sure you've run `idf.py build` or `idf.py idf_size`
        -- or specifically `idf.py gen_compile_commands` in your project root.
      }
    end,

    ['lua_ls'] = function()
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      }
    end,
    -- Add other custom server setups here
  },
}

-- Configure vim.diagnostic globally
vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics inline (can be {prefix = '●'})
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always", -- Or "if_many"
    header = "",
    prefix = "",
  },
})

-- Show diagnostic signs in the sign column
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " } -- Nerd Font icons
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
