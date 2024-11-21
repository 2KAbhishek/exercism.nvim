---@class exercism
local M = {}

---@class exercism.config
---@field exercism_workspace string
---@field default_language string
---@field add_default_keybindings boolean
---@field icons table<string, string>
local config = {
    exercism_workspace = '~/exercism',
    default_language = 'ruby',
    add_default_keybindings = true,
    icons = {
        concept = '',
        practice = '',
    },
}

---@type exercism.config
M.config = config

---@param args exercism.config
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
