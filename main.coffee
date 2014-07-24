BarneyRepl  = require('barney-repl').Repl
R           = require 'ramda'
{CellStore} = require './lib/CellStore.coffee'
_           = require "highland"


Cells = new CellStore()

Repl = new BarneyRepl()

constructCoffee = (cells)-> R.map(R.get("text"), cells).join("\n")

_runById = (id)-> Repl.run(constructCoffee([Cells.getCell(id)]))

_runAll = -> Repl.run(constructCoffee(Cells.getState()))

RUN = (React)->

    {div, h1, h2, h3, h4, h5, li, ul, ol, textarea, span, button, input} = require("./lib/BuildReact.coffee").BuildReact(React)

    Cells_list = React.createClass({
        render: ->
            updateText = R.curry (cb, e)-> cb e.target.value
            createCell = (cell)->
                (li {key: cell._id}, [
                    (h1 cell.title)
                    (textarea {onChange: updateText(Cells.updateText(cell._id))})
                    (button   {onClick:  R.lPartial(Cells.removeCell,cell._id)},  "delete")
                    (button   {onClick:  R.lPartial(_runById, cell._id)},         "run")
                    (button   {onClick:  R.lPartial(Cells.nudgeLeft, cell._id)},  "up")
                    (button   {onClick:  R.lPartial(Cells.nudgeRight, cell._id)}, "down")])
            (ul @props.cells.map(createCell))
    })

    App = React.createClass({
        getInitialState: ->
            cells: []
            output: "run some code to see some output."

        componentDidMount: ->
            self = this
            _("changed", Cells).each (val)-> self.setState {cells: val}
            _("output", Repl).each (val)-> self.setState {output: val}

        render: ->
            (div [
                (button {onClick: Cells.addCell}, "add-cell")
                (button {onClick: _runAll}, "run-all")
                (h5 @state.output)
                (Cells_list {cells: @state.cells})])

    })

    React.renderComponent App(), window.document.body

module.exports.run = RUN
