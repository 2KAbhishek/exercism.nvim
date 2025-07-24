local recents = require('exercism.recents')
local config = require('exercism.config').config

describe('exercism.recents', function()
    local test_file = vim.fn.stdpath('data') .. '/exercism_recents_test.json'

    before_each(function()
        recents._set_test_file(test_file)
        recents.clear_recents()
    end)

    after_each(function()
        vim.fn.delete(test_file)
    end)

    describe('add_recent', function()
        it('should add a new recent entry', function()
            recents.add_recent('ruby', 'hello-world')

            local recent_exercises = recents.get_recents()
            assert.equals(1, #recent_exercises)
            assert.equals('ruby', recent_exercises[1].language)
            assert.equals('hello-world', recent_exercises[1].exercise)
        end)

        it('should move existing entry to top when added again', function()
            recents.add_recent('ruby', 'hello-world')
            recents.add_recent('python', 'two-fer')
            recents.add_recent('ruby', 'hello-world')

            local recent_exercises = recents.get_recents()
            assert.equals(2, #recent_exercises)
            assert.equals('ruby', recent_exercises[1].language)
            assert.equals('hello-world', recent_exercises[1].exercise)
            assert.equals('python', recent_exercises[2].language)
            assert.equals('two-fer', recent_exercises[2].exercise)
        end)

        it('should maintain maximum number of entries', function()
            for i = 1, 35 do
                recents.add_recent('language' .. i, 'exercise' .. i)
            end

            local recent_exercises = recents.get_recents()
            assert.equals(config.max_recents, #recent_exercises)
            assert.equals('language35', recent_exercises[1].language)
            assert.equals('exercise35', recent_exercises[1].exercise)
        end)

        it('should ignore empty language or exercise', function()
            recents.add_recent('', 'hello-world')
            recents.add_recent('ruby', '')
            recents.add_recent('', '')

            local recent_exercises = recents.get_recents()
            assert.equals(0, #recent_exercises)
        end)
    end)

    describe('get_recents', function()
        it('should return empty list when no recents', function()
            local recent_exercises = recents.get_recents()
            assert.equals(0, #recent_exercises)
        end)

        it('should return recents in reverse chronological order', function()
            recents.add_recent('ruby', 'hello-world')
            recents.add_recent('python', 'two-fer')
            recents.add_recent('javascript', 'leap')

            local recent_exercises = recents.get_recents()
            assert.equals(3, #recent_exercises)
            assert.equals('javascript', recent_exercises[1].language)
            assert.equals('leap', recent_exercises[1].exercise)
            assert.equals('python', recent_exercises[2].language)
            assert.equals('two-fer', recent_exercises[2].exercise)
            assert.equals('ruby', recent_exercises[3].language)
            assert.equals('hello-world', recent_exercises[3].exercise)
        end)
    end)

    describe('clear_recents', function()
        it('should clear all recent entries', function()
            recents.add_recent('ruby', 'hello-world')
            recents.add_recent('python', 'two-fer')

            recents.clear_recents()

            local recent_exercises = recents.get_recents()
            assert.equals(0, #recent_exercises)
        end)
    end)

    describe('remove_recent', function()
        it('should remove specific recent entry', function()
            recents.add_recent('ruby', 'hello-world')
            recents.add_recent('python', 'two-fer')
            recents.add_recent('javascript', 'leap')

            local success = recents.remove_recent('python', 'two-fer')

            assert.is_true(success)
            local recent_exercises = recents.get_recents()
            assert.equals(2, #recent_exercises)
            assert.equals('javascript', recent_exercises[1].language)
            assert.equals('leap', recent_exercises[1].exercise)
            assert.equals('ruby', recent_exercises[2].language)
            assert.equals('hello-world', recent_exercises[2].exercise)
        end)

        it('should return false when entry not found', function()
            recents.add_recent('ruby', 'hello-world')

            local success = recents.remove_recent('python', 'two-fer')

            assert.is_false(success)
            local recent_exercises = recents.get_recents()
            assert.equals(1, #recent_exercises)
        end)
    end)

    describe('get_recents_count', function()
        it('should return correct count', function()
            assert.equals(0, recents.get_recents_count())

            recents.add_recent('ruby', 'hello-world')
            assert.equals(1, recents.get_recents_count())

            recents.add_recent('python', 'two-fer')
            assert.equals(2, recents.get_recents_count())

            recents.clear_recents()
            assert.equals(0, recents.get_recents_count())
        end)
    end)

    describe('file persistence', function()
        it('should persist data across instances', function()
            recents.add_recent('ruby', 'hello-world')
            recents.add_recent('python', 'two-fer')

            package.loaded['exercism.recents'] = nil
            local new_recents = require('exercism.recents')
            new_recents._set_test_file(test_file)

            local recent_exercises = new_recents.get_recents()
            assert.equals(2, #recent_exercises)
            assert.equals('python', recent_exercises[1].language)
            assert.equals('two-fer', recent_exercises[1].exercise)
            assert.equals('ruby', recent_exercises[2].language)
            assert.equals('hello-world', recent_exercises[2].exercise)
        end)

        it('should handle corrupted file gracefully', function()
            local file = io.open(test_file, 'w')
            file:write('invalid json content')
            file:close()

            local recent_exercises = recents.get_recents()
            assert.equals(0, #recent_exercises)
        end)

        it('should handle missing file gracefully', function()
            vim.fn.delete(test_file)

            local recent_exercises = recents.get_recents()
            assert.equals(0, #recent_exercises)
        end)
    end)
end)
