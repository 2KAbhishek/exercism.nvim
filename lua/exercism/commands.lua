local main = require('exercism.main')
local config = require('exercism.config').config
local legacy = require('exercism.legacy')

local M = {}

local function add_keymap(keys, cmd, desc)
    vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
end

local function add_default_keymaps()
    add_keymap('<leader>exa', ':Exercism languages<CR>', 'All Exercism Languages')
    add_keymap('<leader>exl', ':Exercism list<CR>', 'Exercism List')
    add_keymap('<leader>ext', ':Exercism test<CR>', 'Exercism Test')
    add_keymap('<leader>exs', ':Exercism submit<CR>', 'Exercism Submit')
end

-- Tab completion function for the unified Exercism command
local function exercism_complete(arg_lead, cmd_line, cursor_pos)
    local args = vim.split(cmd_line, '%s+')
    local num_args = #args

    -- Remove 'Exercism' from args count
    if args[1] == 'Exercism' then
        num_args = num_args - 1
        table.remove(args, 1)
    end

    if num_args == 0 or (num_args == 1 and arg_lead ~= '') then
        local subcommands = { 'languages', 'list', 'test', 'submit' }
        local matches = {}

        for _, cmd in ipairs(subcommands) do
            if cmd:match('^' .. vim.pesc(arg_lead)) then
                table.insert(matches, cmd)
            end
        end

        return matches
    end

    if num_args == 2 and args[1] == 'list' then
        local languages = main.get_available_languages()
        local matches = {}

        for _, lang in ipairs(languages) do
            if lang:match('^' .. vim.pesc(arg_lead)) then
                table.insert(matches, lang)
            end
        end

        return matches
    end

    return {}
end

-- Main command handler
local function exercism_command(opts)
    local args = vim.split(opts.args, '%s+')
    local subcommand = args[1]

    if not subcommand or subcommand == '' then
        vim.notify(
            'Usage: Exercism <subcommand> [args]\nSubcommands: languages, list [language], test, submit',
            vim.log.levels.INFO
        )
        return
    end

    if subcommand == 'languages' then
        main.list_languages()
    elseif subcommand == 'list' then
        local language = args[2]
        main.list_exercises(language)
    elseif subcommand == 'test' then
        main.test_exercise()
    elseif subcommand == 'submit' then
        main.submit_exercise()
    else
        vim.notify(
            'Unknown subcommand: ' .. subcommand .. '\nAvailable: languages, list [language], test, submit',
            vim.log.levels.ERROR
        )
    end
end

M.setup = function()
    if config.use_new_command then
        vim.api.nvim_create_user_command('Exercism', exercism_command, {
            nargs = '*',
            complete = exercism_complete,
            desc = 'Exercism integration commands',
        })

        if config.add_default_keybindings then
            add_default_keymaps()
        end
    else
        vim.notify(
            'Legacy Exercism commands are deprecated and will be removed on 15th August 2025.\n'
                .. 'Please switch the new `:Exercism` command by adding `use_new_command` in your config.\n'
                .. 'More info: https://github.com/2kabhishek/exercism.nvim/issues/13',
            vim.log.levels.WARN
        )

        legacy.setup_legacy_commands()
        legacy.setup_legacy_keybindings()
    end
end

return M
