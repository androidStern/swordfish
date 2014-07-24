{findIndex, compose, concat, append, nth, curry, map, where, find, reject, flip, mixin} = require 'ramda'
_ = require 'lodash'
{Store} = require "./Store"
{mixWith, toObj, applyIf, applyWhen, applyWhere, updateWhere, findWhere, set, removeWhere, shuffleAtIdx} = require './utils'
{mustBeString, mustBeMap, mustBeArray, mustBeFunction} = require "./Validation.coffee"

class CellStore extends Store
    constructor: ->
        super(this)
        self = this

        _addCell = -> self.add {title: "", text: ""}

        _removeCell = mustBeString (_id)->
            self.removeWhere(_id: _id)

        _updateCell = curry (_id, key, val)->
            if not _.isString(key) then return
            self.update({_id: _id}, key, val)

        _updateCellText = curry (_id, txt)->
            if not _.isString(txt) then return
            _updateCell(_id, "text", txt)

        _updateCellTitle = curry (_id, title)->
            if not _.isString(title) then return
            _updateCell(_id, "title", title)

        _getCell = (_id)-> self.findWhere({_id: _id})

        _nudge = curry (dist, _id)->
          self.setState shuffleAtIdx(findIndex(where({_id: _id}),
                                     self.getState()),
                                     dist, self.getState())

        self.updateText = _updateCellText
        self.updateTitle = _updateCellTitle
        self.addCell = _addCell
        self.removeCell = _removeCell
        self.getCell = _getCell
        self.nudge = _nudge
        self.nudgeLeft = _nudge(-1)
        self.nudgeRight = _nudge(1)

module.exports.CellStore = CellStore
