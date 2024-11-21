---@class exercism
local M = {}

---@class exercism.config
---@field name string
---@field exercism_workspace string
---@field add_default_keybindings boolean
local config = {
    name = 'World!',
    add_default_keybindings = true,
    exercism_workspace = '~/exercism',
    icons = {
        concept = '',
        practice = '',
    }
}

---@type exercism.config
M.config = config

---@param args exercism.config
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
