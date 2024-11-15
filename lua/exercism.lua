return {
    setup = function(opts)
        require('exercism.config').setup(opts)
        require('exercism.commands').setup()
    end,
}
