local main = require('exercism.main')
local config = require('exercism.config').config
local legacy = require('exercism.legacy')

---@type string
local default_language = config.default_language

---@class ExercismCommands
local M = {}

---Add default keybindings for Exercism commands
local function add_default_keymaps()
    local function add_keymap(keys, cmd, desc)
        vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
    end

    add_keymap('<leader>exa', ':Exercism languages<CR>', 'All Exercism Languages')
    add_keymap('<leader>exl', ':Exercism list<CR>', 'Exercism List')
    add_keymap('<leader>ext', ':Exercism test<CR>', 'Exercism Test')
    add_keymap('<leader>exs', ':Exercism submit<CR>', 'Exercism Submit')
end

---Parse command line arguments
---@param cmd_line string
---@return string[]
local function parse_command_line(cmd_line)
    local args = {}
    for arg in cmd_line:gmatch('%S+') do
        table.insert(args, arg)
    end

    if args[1] == 'Exercism' then
        table.remove(args, 1)
    end

    return args
end

---Filter items by prefix match
---@param items string[]
---@param prefix string
---@return string[]
local function filter_by_prefix(items, prefix)
    local matches = {}

    for _, item in ipairs(items) do
        if item:find('^' .. vim.pesc(prefix or ''), 1, false) then
            table.insert(matches, item)
        end
    end

    return matches
end

---Complete subcommands
---@param arg_lead string
---@return string[]
local function complete_subcommands(arg_lead)
    local subcommands = { 'languages', 'list', 'test', 'submit', 'open', 'exercise' }
    return filter_by_prefix(subcommands, arg_lead)
end

---Complete languages
---@param arg_lead string
---@return string[]
local function complete_languages(arg_lead)
    local languages = main.get_available_languages()
    return filter_by_prefix(languages, arg_lead)
end

---Complete exercises for a specific language
---@param language string
---@param arg_lead string
---@return string[]
local function complete_exercises(language, arg_lead)
    local exercises = main.get_exercise_names(language)
    return filter_by_prefix(exercises, arg_lead)
end

---Determine if we're completing at a specific position
---@param args string[]
---@param position integer
---@param cmd_line string
---@return boolean
local function is_completing_at_position(args, position, cmd_line)
    return (#args == position - 1) or (#args == position and not cmd_line:match('%s$'))
end

---Tab completion function for the unified Exercism command
---@param arg_lead string
---@param cmd_line string
---@param cursor_pos integer
---@return string[]
local function exercism_complete(arg_lead, cmd_line, cursor_pos)
    local args = parse_command_line(cmd_line)

    if is_completing_at_position(args, 1, cmd_line) then
        return complete_subcommands(arg_lead)
    end

    local subcommand = args[1]

    if subcommand == 'list' then
        if is_completing_at_position(args, 2, cmd_line) then
            return complete_languages(arg_lead)
        end
    elseif subcommand == 'open' then
        if is_completing_at_position(args, 2, cmd_line) then
            return complete_languages(arg_lead)
        elseif is_completing_at_position(args, 3, cmd_line) and #args >= 2 then
            return complete_exercises(args[2], arg_lead)
        end
    elseif subcommand == 'exercise' then
        if is_completing_at_position(args, 2, cmd_line) then
            return complete_exercises(default_language, arg_lead)
        end
    end

    return {}
end

---Main command handler
---@param opts table
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
        main.list_exercises(args[2])
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

---Setup function to initialize commands
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
