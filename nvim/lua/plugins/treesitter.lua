-- ~/.config/nvim/lua/plugins/treesitter.lua
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c", "cpp", "lua", "vim", "vimdoc", "python", "json", "yaml",
    "markdown", "markdown_inline", "bash", "html", "css", "javascript", "typescript",
    -- Add other languages you use frequently
  },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  auto_install = true, -- automatically install missing parsers when entering buffer
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    -- disable = { "yaml" }, -- example to disable for a language
  },
  -- Other modules:
  -- matchup = { enable = true },
  -- textobjects = { enable = true },
}
