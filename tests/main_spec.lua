local exercism = require('exercism')
local main = require('exercism.main')

describe('greet', function()
    it('returns message with config value', function()
        exercism.setup()
        assert(main.greet() == 'Hello World!')
    end)

    it('returns message with user arg', function()
        exercism.setup()
        assert(main.greet('Neovim') == 'Hello Neovim')
    end)
end)
