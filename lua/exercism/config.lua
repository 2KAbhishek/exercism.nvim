-- Define config structure here, setup function will override defaults with user config
---@class ExercismModule
local M = {}

---@class ExercismConfig
---@field name string
---@field add_default_keybindings boolean
local config = {
    name = 'World!',
    exercism_workspace = vim.fn.expand('~/exercism'),
    add_default_keybindings = true,
}

---@type ExercismConfig
M.config = config

---@param args ExercismConfig?
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
