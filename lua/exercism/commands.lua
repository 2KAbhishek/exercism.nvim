local exercism_module = require('exercism.module')
local config = require('exercism.config').config

local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('ExercismList', function(opts)
        local language = vim.split(opts.args, ' ')[1]
        exercism_module.list_exercises(language)
    end, { nargs = '?' })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        if config.add_default_keybindings then
            add_keymap('<leader>goe', ':ExercismList lua<CR>', 'Exercism says hi')
        end
    end
end

return M
