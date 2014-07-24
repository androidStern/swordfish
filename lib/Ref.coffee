EE = require('events').EventEmitter
{cloneDeep} = require 'lodash'

class Ref extends EE
    constructor: (initial_state = {})->
        self = this
        EE.call(this)
        _state = cloneDeep(initial_state)

        Object.defineProperty(this, "setState", {
            enumerable: true
            configurable: true
            writable: false
            value: (new_state)->
                _state = new_state
                self.emit "changed", _state
            })

        Object.defineProperty(this, "getState", {
            enumerable: true
            configurable: true
            writable: false
            value: -> cloneDeep _state
            })

module.exports.Ref = Ref
