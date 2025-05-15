-- ~/.config/nvim/lua/plugins/cmp.lua
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly-snippets if you want them
-- require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', require("plugins.lsp.icons").kind[vim_item.kind] or '', vim_item.kind) -- Optional: icons for completion items
      -- Source menu name
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true, -- Shows completion inline as ghost text
  }
})

-- Setup nvim-cmp for command line mode
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Optional: Add icons for LSP kinds (create lua/plugins/lsp/icons.lua)
-- ~/.config/nvim/lua/plugins/lsp/icons.lua
-- return {
--   kind = {
--     Text = "",
--     Method = "",
--     Function = "",
--     Constructor = "",
--     Field = "ﴲ",
--     Variable = "Variables",
--     Class = "𝓒",
--     Interface = "",
--     Module = "",
--     Property = "ﰠ",
--     Unit = "塞",
--     Value = "",
--     Enum = "",
--     Keyword = "",
--     Snippet = "",
--     Color = "",
--     File = "",
--     Reference = "",
--     Folder = "",
--     EnumMember = "",
--     Constant = "",
--     Struct = "",
--     Event = "",
--     Operator = "Ψ",
--     TypeParameter = "typeparam",
--     Codeium = "Codeium",
--     TabNine = "TabNine",
--   },
--   type = {
--     Error = "",
--     Warn = "",
--     Info = "",
--     Hint = "",
--   },
-- }
