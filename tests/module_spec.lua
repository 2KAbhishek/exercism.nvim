local exercism = require('exercism')
local module = require('exercism.module')

describe('greet', function()
    it('returns message with config value', function()
        exercism.setup()
        assert(module.greet() == 'Hello World!')
    end)

    it('returns message with user arg', function()
        exercism.setup()
        assert(module.greet('Neovim') == 'Hello Neovim')
    end)
end)
