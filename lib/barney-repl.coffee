through = require 'through2'
coffee_repl = require 'coffee-script/lib/coffee-script/repl'
util = require 'util'

EE = require('events').EventEmitter

Repl = ->
    self = this
    EE.call(this)
    input = new through()
    output = new through()
    r = coffee_repl.start({output: output, input: input, prompt: ""})
    r.displayPrompt = ->
    r.rli.output.cursorTo = ->
    r.rli.output.clearLine = ->
    r.rli.output.displayPrompt = ->
    run = (code)->
        r.inputStream.emit "keypress", null, {name: 'v', ctrl: true}
        r.rli.emit("line", code)
        r.inputStream.emit "keypress", null, {name: 'v', ctrl: true}
        return self
    r.outputStream.on "data", (d)-> self.emit "output", d.toString()
    self.run = run
    return self

util.inherits Repl, EE
