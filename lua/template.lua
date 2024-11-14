return {
    setup = function(opts)
        require('template.config').setup(opts)
        require('template.commands').setup()
    end,
}
