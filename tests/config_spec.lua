local config = require('exercism.config')

describe('exercism.config', function()
    local default_config = {
        exercism_workspace = '~/exercism',
        default_language = 'ruby',
        add_default_keybindings = true,
        icons = {
            concept = '',
            practice = '',
        },
    }

    before_each(function()
        config.setup(vim.deepcopy(default_config))
    end)

    it('has default values', function()
        assert.are.same(config.config.exercism_workspace, '~/exercism')
        assert.are.same(config.config.default_language, 'ruby')
        assert.are.same(config.config.add_default_keybindings, true)
        assert.are.same(config.config.icons.concept, '')
        assert.are.same(config.config.icons.practice, '')
    end)

    it('can be overridden', function()
        local new_config = {
            exercism_workspace = '~/my_exercism',
            default_language = 'python',
            add_default_keybindings = false,
            icons = {
                concept = '',
                practice = '',
            },
        }
        config.setup(new_config)
        assert.are.same(config.config.exercism_workspace, '~/my_exercism')
        assert.are.same(config.config.default_language, 'python')
        assert.are.same(config.config.add_default_keybindings, false)
        assert.are.same(config.config.icons.concept, '')
        assert.are.same(config.config.icons.practice, '')
    end)

    it('merges partial overrides', function()
        local partial_config = {
            default_language = 'go',
        }
        config.setup(partial_config)
        assert.are.same(config.config.exercism_workspace, '~/exercism')
        assert.are.same(config.config.default_language, 'go')
        assert.are.same(config.config.add_default_keybindings, true)
        assert.are.same(config.config.icons.concept, '')
        assert.are.same(config.config.icons.practice, '')
    end)
end)
