-- ~/.config/nvim/lua/core/keymaps.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key is already set in init.lua

-- General
map('n', '<leader>/', ':noh<CR>', { silent = true, desc = "Clear search highlight" })
map('n', '<leader>w', ':w<CR>', { desc = "Save file" })
map('n', '<leader>q', ':q<CR>', { desc = "Quit" })
map('n', '<leader>wq', ':wq<CR>', { desc = "Save and Quit" })
map('n', '<leader>bd', ':Bclose<CR>', { desc = "Close buffer (custom command needed)" }) -- We'll need to define Bclose or use an alternative

-- Window navigation (your C-hjkl mappings)
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to below window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to above window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Tab navigation
map('n', '<leader>tn', ':tabnew<CR>', { desc = "New tab" })
map('n', '<leader>tc', ':tabclose<CR>', { desc = "Close tab" })
map('n', '<leader>to', ':tabonly<CR>', { desc = "Tab only" })
map('n', '<S-L>', ':tabn<CR>', { desc = "Next tab" })     -- Shift-L
map('n', '<S-H>', ':tabp<CR>', { desc = "Previous tab" }) -- Shift-H

-- Buffer navigation (consider Telescope for buffers: <leader>fb)
map('n', '[b', ':bprevious<CR>', { desc = "Previous buffer" })
map('n', ']b', ':bnext<CR>', { desc = "Next buffer" })

-- Your F-key mappings (translate or re-evaluate)
-- map('n', '<F6>', ':setlocal spell!<CR>', { desc = "Toggle spell check" })
-- For F8 background toggle, you can use a Lua function
-- map('n', '<F8>', function() vim.opt.background = (vim.opt.background:get() == 'dark' and 'light' or 'dark') end, { desc = "Toggle background" })

-- Paste over without overwriting register
map('x', 'p', '"_dP', { desc = "Paste without yanking" }) -- Common alternative

-- Toggle paste mode
map('n', '<leader>pp', ':set paste!<CR>', { desc = "Toggle paste mode" })

-- Telescope keymaps are in plugins/telescope.lua for now, or move them here
-- LSP keymaps are in plugins/lsp/init.lua for now, or move them here

-- Commenting with Comment.nvim
-- Visual mode: gc
-- Normal mode: gcc (line), gc + motion
map('n', '<leader>c<space>', 'gcc', { remap = true, desc = "Comment line" })
map('v', '<leader>c<space>', 'gc', { remap = true, desc = "Comment selection" })


-- Your custom mappings for quick insert of pairs (nvim-autopairs handles most of this)
-- e.g., inoremap <space>( ()<esc>i
-- nvim-autopairs will automatically insert the closing pair.

-- For your ; and ;; mappings
map('n', ';', ':', { noremap = false }) -- Allow remapping if needed later
map('n', ';;', ';', opts)

-- Move lines
map('n', '<M-j>', ':m .+1<CR>==', { desc = "Move line down" })
map('n', '<M-k>', ':m .-2<CR>==', { desc = "Move line up" })
map('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Terminal
map('n', '<leader>tt', ':ToggleTerm<CR>', { desc = "Toggle terminal (needs a terminal plugin like toggleterm.nvim)" })
-- If you install toggleterm.nvim:
-- { 'akinsho/toggleterm.nvim', version = "*", config = true }
-- Then in its config:
-- require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = 'float' })
-- map('n', '<c-\\>', ':ToggleTerm<CR>', { desc = "Toggle Terminal" })


-- Example: Define Bclose command in Lua if you don't use a plugin for it
vim.api.nvim_create_user_command('Bclose', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local bufs = vim.api.nvim_list_bufs()
    local listed_alt_buf = nil

    for _, buf in ipairs(bufs) do
        if buf ~= current_buf and vim.bo[buf].buflisted then
            local alt_buf_info = vim.fn.getbufinfo(buf)
            if alt_buf_info and #alt_buf_info > 0 and alt_buf_info[1].lastused then
                if not listed_alt_buf or alt_buf_info[1].lastused > vim.fn.getbufinfo(listed_alt_buf)[1].lastused then
                    listed_alt_buf = buf
                end
            end
        end
    end

    if listed_alt_buf then
        vim.api.nvim_set_current_buf(listed_alt_buf)
    else
        vim.cmd('enew') -- Open a new empty buffer if no other listed buffer
    end

    if vim.bo[current_buf].buflisted and #vim.api.nvim_list_wins() > 0 then
       pcall(vim.cmd, 'bdelete! ' .. current_buf)
    end
end, {})

print("Keymaps loaded") -- For debugging
