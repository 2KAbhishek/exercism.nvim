---@class ExercismConfig
local M = {}

---@class ExercismConfigOptions
---@field exercism_workspace string Default workspace for exercism exercises
---@field default_language string Default language for exercise list
---@field add_default_keybindings boolean Whether to add default keybindings
---@field max_recents integer Maximum number of recent exercises to keep
---@field icons table<string, string> Icons for different exercise types

---@type ExercismConfigOptions
local config = {
    exercism_workspace = '~/exercism',
    default_language = 'ruby',
    add_default_keybindings = true,
    max_recents = 30,
    icons = {
        concept = '',
        practice = '',
    },
}

---@type ExercismConfigOptions
M.config = config

---Setup configuration with user options
---@param args ExercismConfigOptions?
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
