local utils = require('utils')
local Path = require('plenary.path')
local config = require('exercism.config').config

---@class exercism.main
local M = {}

---@param language string
---@return any
local function get_exercise_data(language)
    local script_path = debug.getinfo(1, 'S').source:sub(2)
    local plugin_path = vim.fn.fnamemodify(script_path, ':h:h:h')
    local exercise_file = plugin_path .. '/data/' .. language .. '.json'
    local exercise_data = vim.fn.json_decode(vim.fn.readfile(exercise_file))
    return exercise_data
end

---@param exercise_name string
---@param language string?
---@return string
local function get_exercise_dir(exercise_name, language)
    return vim.fn.expand(config.exercism_workspace .. '/' .. language .. '/' .. exercise_name)
end

---@param language string
M.list_exercises = function(language)
    local exercise_data = get_exercise_data(language)

    if #exercise_data > 0 then
        vim.ui.select(exercise_data, {
            prompt = 'Select Exercise (' .. language .. ')',
            format_item = function(exercise)
                return exercise.name .. ' : ' .. exercise.type
            end,
        }, function(selected_exercise, _)
            if not selected_exercise then
                return
            end
            local exercise_dir = get_exercise_dir(selected_exercise.name, language)

            if not Path:new(exercise_dir):exists() then
                local download_cmd =
                    string.format('exercism download --track=%s --exercise=%s', language, selected_exercise.name)

                utils.show_notification(
                    'Setting up exercise: ' .. selected_exercise.name .. ' in ' .. language,
                    vim.log.levels.INFO,
                    'Exercism'
                )

                utils.async_shell_execute(download_cmd, function(result)
                    if result then
                        utils.open_dir(exercise_dir)
                    end
                end)
            else
                utils.open_dir(exercise_dir)
            end
        end)
    end
end

return M
