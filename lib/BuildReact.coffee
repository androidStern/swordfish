{isArray} = require 'lodash'

module.exports.BuildReact = (React)->
    build_tag = (tag) ->
          (options...) ->
            options.unshift {} unless typeof options[0] is 'object' and not isArray(options[0])
            React.DOM[tag].apply @, options

    do ->
        object = {}
        for element in Object.keys(React.DOM)
            object[element] = build_tag element
        object
