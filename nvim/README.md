```
~/.config/nvim/
├── init.lua
└── lua/
    ├── plugins.lua
    ├── core/       -- For core settings like options, keymaps
    │   ├── options.lua
    │   └── keymaps.lua
    │   └── autocmds.lua
    └── plugins/    -- For plugin configurations
        ├── lsp/
        │   ├── init.lua
        │   └── settings/ -- Optional: for specific LSP server settings
        └── telescope.lua
        └── treesitter.lua
        └── cmp.lua
        -- ... other plugin config files
```
