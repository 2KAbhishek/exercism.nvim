-- Define config structure here, setup function will override defaults with user config
---@class TemplateModule
local M = {}

---@class TemplateConfig
---@field name string
---@field add_default_keybindings boolean
local config = {
    name = 'World!',
    add_default_keybindings = true,
}

---@type TemplateConfig
M.config = config

---@param args TemplateConfig?
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
