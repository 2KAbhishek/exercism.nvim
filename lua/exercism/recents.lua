---@class ExercismRecents
local M = {}

---@class ExercismRecentEntry
---@field language string
---@field exercise string

local config = require('exercism.config').config

local data_path = vim.fn.stdpath('data')
local recents_file = data_path .. '/exercism_recents.json'

---Set test file for testing purposes
---@param test_file string
function M._set_test_file(test_file)
    recents_file = test_file
end

---Load recent exercises from file
---@return ExercismRecentEntry[]
M.load_recents = function()
    local file = io.open(recents_file, 'r')
    if not file then
        return {}
    end
    local content = file:read('*all')
    file:close()

    local ok, data = pcall(vim.json.decode, content)
    if ok and type(data) == 'table' then
        return data
    end
    return {}
end

---Save recent exercises to file
---@param recents ExercismRecentEntry[]
M.save_recents = function(recents)
    if vim.fn.isdirectory(data_path) == 0 then
        vim.fn.mkdir(data_path, 'p')
    end
    local file = io.open(recents_file, 'w')
    if file then
        file:write(vim.json.encode(recents))
        file:close()
    end
end

---Add or update a recent exercise entry
---@param language string
---@param exercise string
M.add_recent = function(language, exercise)
    if not language or language == '' or not exercise or exercise == '' then
        return
    end

    local recents = M.load_recents()
    local max_recents = config.max_recents

    for i, recent in ipairs(recents) do
        if recent.language == language and recent.exercise == exercise then
            table.remove(recents, i)
            break
        end
    end

    table.insert(recents, 1, {
        language = language,
        exercise = exercise,
    })

    while #recents > max_recents do
        table.remove(recents, #recents)
    end

    M.save_recents(recents)
end

---Get all recent exercises
---@return ExercismRecentEntry[]
M.get_recents = function()
    return M.load_recents()
end

---Clear all recent exercises
M.clear_recents = function()
    M.save_recents({})
end

---Show recent exercises in a fuzzy searchable list
M.show_recents = function()
    local recents = M.get_recents()

    if #recents == 0 then
        vim.notify('No recent exercises found', vim.log.levels.INFO)
        return
    end

    vim.ui.select(recents, {
        prompt = 'Recent Exercises:',
        format_item = function(item)
            return item.language .. '/' .. item.exercise
        end,
    }, function(selected_item)
        if not selected_item then
            return
        end

        local main = require('exercism.main')
        main.open_exercise(selected_item.exercise, selected_item.language)
    end)
end

---Get recent exercises count
---@return number
M.get_recents_count = function()
    local recents = M.load_recents()
    return #recents
end

---Remove a specific recent exercise
---@param language string
---@param exercise string
---@return boolean success
M.remove_recent = function(language, exercise)
    local recents = M.load_recents()

    for i, recent in ipairs(recents) do
        if recent.language == language and recent.exercise == exercise then
            table.remove(recents, i)
            M.save_recents(recents)
            return true
        end
    end

    return false
end

return M
