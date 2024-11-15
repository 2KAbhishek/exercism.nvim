local exercism_module = require('exercism.module')
local config = require('exercism.config')

local M = {}

M.setup = function()
    -- Add all user commands here
    vim.api.nvim_create_user_command('ExercismHello', function(opts)
        exercism_module.greet(opts.args)
    end, { nargs = '?' })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        -- Add all keybindings here
        add_keymap('<leader>Th', ':ExercismHello Neovim (btw!)<CR>', 'Exercism says hi')
    end
end

return M
