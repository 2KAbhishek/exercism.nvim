local main = require('exercism.main')
local config = require('exercism.config').config
local legacy = require('exercism.legacy')
local default_language = config.default_language

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
    local words = {}
    for word in cmd_line:gmatch('%S+') do
        table.insert(words, word)
    end

    if words[1] == 'Exercism' then
        table.remove(words, 1)
    end

    local completing_subcommand = (#words == 0) or (#words == 1 and not cmd_line:match('%s$'))

    if completing_subcommand then
        local subcommands = { 'languages', 'list', 'test', 'submit', 'open', 'exercise' }
        local matches = {}

        for _, cmd in ipairs(subcommands) do
            if cmd:find('^' .. vim.pesc(arg_lead or ''), 1, false) then
                table.insert(matches, cmd)
            end
        end

        return matches
    elseif #words >= 1 and words[1] == 'list' then
        local completing_language = (#words == 1) or (#words == 2 and not cmd_line:match('%s$'))

        if completing_language then
            local languages = main.get_available_languages()
            local matches = {}

            for _, lang in ipairs(languages) do
                if lang:find('^' .. vim.pesc(arg_lead or ''), 1, false) then
                    table.insert(matches, lang)
                end
            end

            return matches
        end
    elseif #words >= 1 and words[1] == 'open' then
        -- Complete language first, then exercise name for that language
        local completing_language = (#words == 1) or (#words == 2 and not cmd_line:match('%s$'))
        local completing_exercise = (#words == 2) or (#words == 3 and not cmd_line:match('%s$'))

        if completing_language then
            local languages = main.get_available_languages()
            local matches = {}

            for _, lang in ipairs(languages) do
                if lang:find('^' .. vim.pesc(arg_lead or ''), 1, false) then
                    table.insert(matches, lang)
                end
            end

            return matches
        elseif completing_exercise and #words >= 2 then
            local language = words[2]
            local exercises = main.get_exercise_names(language)
            local matches = {}

            for _, exercise in ipairs(exercises) do
                if exercise:find('^' .. vim.pesc(arg_lead or ''), 1, false) then
                    table.insert(matches, exercise)
                end
            end

            return matches
        end
    elseif #words >= 1 and words[1] == 'exercise' then
        -- Complete exercise name for default language
        local completing_exercise = (#words == 1) or (#words == 2 and not cmd_line:match('%s$'))

        if completing_exercise then
            local exercises = main.get_exercise_names(default_language)
            local matches = {}

            for _, exercise in ipairs(exercises) do
                if exercise:find('^' .. vim.pesc(arg_lead or ''), 1, false) then
                    table.insert(matches, exercise)
                end
            end

            return matches
        end
    end

    return {}
end

-- Main command handler
local function exercism_command(opts)
    local args = vim.split(opts.args, '%s+')
    local subcommand = args[1]

    if not subcommand or subcommand == '' then
        vim.notify(
            'Usage: Exercism <subcommand> [args]\nSubcommands: languages, list [language], test, submit, open <language> <exercise>, exercise <exercise>',
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
    elseif subcommand == 'open' then
        local language = args[2]
        local exercise_name = args[3]

        if not language or not exercise_name then
            vim.notify('Usage: Exercism open <language> <exercise>', vim.log.levels.ERROR)
            return
        end

        main.open_exercise(exercise_name, language)
    elseif subcommand == 'exercise' then
        local exercise_name = args[2]

        if not exercise_name then
            vim.notify('Usage: Exercism exercise <exercise>', vim.log.levels.ERROR)
            return
        end
        main.open_exercise(exercise_name, default_language)
    else
        vim.notify(
            'Unknown subcommand: '
                .. subcommand
                .. '\nAvailable: languages, list [language], test, submit, open <language> <exercise>, exercise <exercise>',
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
