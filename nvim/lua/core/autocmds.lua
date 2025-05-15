-- ~/.config/nvim/lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Clear augroup if it already exists
local function create_augroup(name)
    vim.cmd("augroup " .. name)
    vim.cmd("autocmd!") -- Clear existing autocmds in this group
    vim.cmd("augroup END")
    return augroup(name, { clear = false }) -- Create it properly for nvim_create_autocmd
end

local general_settings_group = create_augroup('GeneralSettings')
local filetype_settings_group = create_augroup('FileTypeSettings')
local large_file_group = create_augroup('LargeFileSettings') -- Your LargeFile augroup

-- Return to last edit position
autocmd('BufReadPost', {
  group = general_settings_group,
  pattern = '*',
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 0 and last_pos <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
      vim.cmd('normal! zz') -- Center the line
    end
    -- Call your UpdateCopyright if you translate it to Lua or keep it in Vimscript
    -- pcall(vim.cmd, 'call UpdateCopyright()')
  end,
})

-- Delete trailing whitespace and update copyright on save
autocmd('BufWritePre', {
  group = general_settings_group,
  pattern = '*',
  callback = function()
    local view = vim.fn.winsaveview()
    -- Delete trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
    -- Call your UpdateCopyright
    -- pcall(vim.cmd, 'call UpdateCopyright()')
    -- Your backup extension logic can be done here too
    -- vim.opt.backupext = '.-' .. vim.fn.strftime('%Y%m%d-%H%M%S')
  end,
})


-- Your comment leader logic (can be simplified with Comment.nvim plugin)
-- Example for python, if not using Comment.nvim
autocmd('FileType', {
  group = filetype_settings_group,
  pattern = 'python',
  callback = function()
    vim.b.comment_leader = '#  '
    -- For omnifunc, nvim-cmp + LSP handles this better
    -- vim.bo.omnifunc = 'pythoncomplete#Complete'
  end,
})
-- Add more for other filetypes if you don't use Comment.nvim

-- Large file handling (your existing logic translated)
local G_LARGE_FILE_SIZE = 10000000 -- ~10MB
autocmd("BufReadPre", {
    group = large_file_group,
    pattern = "*",
    callback = function(args)
        local file = args.file
        local fsize = vim.fn.getfsize(file)
        if fsize > G_LARGE_FILE_SIZE or fsize == -2 then -- -2 if file doesn't exist
            vim.opt_local.swapfile = false
            vim.opt_local.bufhidden = "unload"
            -- vim.opt_local.buftype = "nowrite" -- Careful with this, makes buffer read-only
            vim.opt_local.undolevels = -1
            vim.cmd("set eventignore+=FileType") -- Disable FileType event
            print("Large file mode activated for: " .. file)
        else
            vim.cmd("set eventignore-=FileType")
        end
    end,
})

-- Highlight yanked text
autocmd('TextYankPost', {
    group = general_settings_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
    end,
})


-- Auto resize panes on VimResize event
autocmd("VimResized", {
    group = general_settings_group,
    pattern = "*",
    command = "wincmd =",
    desc = "Auto resize panes on VimResized"
})

print("Autocmds loaded") -- For debugging
