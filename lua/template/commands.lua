local template_module = require('template.module')
local config = require('template.config')

local M = {}

M.setup = function()
    -- Add all user commands here
    vim.api.nvim_create_user_command('TemplateHello', function(opts)
        template_module.greet(opts.args)
    end, { nargs = '?' })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        -- Add all keybindings here
        add_keymap('<leader>Th', ':TemplateHello Neovim (btw!)<CR>', 'Template says hi')
    end
end

return M
