local main = require('exercism.main')
local config = require('exercism.config').config

local M = {}

M.setup_legacy_commands = function()
    vim.api.nvim_create_user_command('ExercismLanguages', function(_)
        main.list_languages()
    end, {})

    vim.api.nvim_create_user_command('ExercismList', function(opts)
        local language = vim.split(opts.args, ' ')[1]
        main.list_exercises(language)
    end, { nargs = '?' })

    vim.api.nvim_create_user_command('ExercismTest', function(_)
        main.test_exercise()
    end, {})

    vim.api.nvim_create_user_command('ExercismSubmit', function(_)
        main.submit_exercise()
    end, {})
end

M.setup_legacy_keybindings = function()
    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        add_keymap('<leader>exa', ':ExercismLanguages<CR>', 'All Exercism Languages')
        add_keymap('<leader>exl', ':ExercismList<CR>', 'Exercism List')
        add_keymap('<leader>ext', ':ExercismTest<CR>', 'Exercism Test')
        add_keymap('<leader>exs', ':ExercismSubmit<CR>', 'Exercism Submit')
    end
end

return M
