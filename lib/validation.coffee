R = require 'ramda'
_ = require 'lodash'

Validator = (message, fn)->
    {message: message, fn: fn}

Checker = R.curry (validators, fn)->
    origional_fn = fn
    (args...)->
        reducer = (acc, validator)->
            {fn, message} = validator
            message ?= "FAILED but no error message available"
            if fn.call(null, args[0]) then acc else R.cons(message, acc)

        errors = _.reduce(validators, reducer, [])

        if errors.length > 0
            err_message = errors.join(", ")
            throw new Error(err_message)

        return origional_fn.apply(null, args)

mustBeMap = Checker([
    Validator("Argument must be a map", _.isPlainObject)
    ])

mustBeArray = Checker([
    Validator("Argument must be an array", _.isArray)
    ])

mustBeFunction = Checker([
    Validator("Argument must be a funtion", _.isFunction)
    ])

mustBeString = Checker([
    Validator("Argument must be a string", _.isString)
    ])


module.exports = {
    Validator: Validator
    Checker: Checker
    mustBeMap: mustBeMap
    mustBeArray: mustBeArray
    mustBeFunction: mustBeFunction
    mustBeString: mustBeString
}

# Validator, Checker, mustBeMap, mustBeArray, mustBeFunction, mustBeString
