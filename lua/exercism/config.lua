---@class ExercismConfig
local M = {}

---@class ExercismConfigOptions
---@field exercism_workspace string
---@field default_language string
---@field add_default_keybindings boolean
---@field use_new_command boolean
---@field icons table<string, string>

---@type ExercismConfigOptions
local config = {
    exercism_workspace = '~/exercism',
    default_language = 'ruby',
    add_default_keybindings = true,
    use_new_command = false,
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
