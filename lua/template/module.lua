---@class CustomModule
local M = {}
local config = require('template.config').config

---@return string
M.greet = function(name)
    name = name and #name > 0 and name or config.name

    M.show_notification('Hello ' .. name)
    return 'Hello ' .. name
end

M.show_notification = function(message)
    vim.notify(message, vim.log.levels.INFO, {
        title = 'Template',
        timeout = 5000,
    })
end

return M
