{concat, append, nth, curry, map, where, find, reject, flip, mixin} = require 'ramda'
# _ = require 'ramda'

set = curry (key, val, item)->
    o = {}
    o[key] = val
    mixin item, o

mixWith = flip(mixin)

toObj = (key, value)->
    _obj = {}
    _obj[key] = value
    return _obj

applyIf = curry (fn, pred, arg)-> if pred(arg) then fn(arg) else arg

applyWhen = curry (fn, pred, list)-> map applyIf(fn, pred), list

applyWhere = curry (fn, spec, list)-> applyWhen(fn, where(spec), list)

updateWhere = curry (spec, key, val, list)->
    applyWhere(mixWith(toObj(key,val)), spec, list)

findWhere = curry (spec, list)-> find(where(spec), list)

removeWhere = curry (spec, list)-> reject where(spec), list


removeAtIdx = curry (idx, list)->
    equalsIdx = (val, index)-> idx is index
    reject.idx equalsIdx, list


shuffleAtIdx = curry (start, dist, list)->
    item = nth(start, list)
    ###*
     * Don't allow moving below 0
    ###
    delta = Math.max((start + dist), 0)
    ###*
     * Don't allow moving past the end of the list
    ###
    end_idx = Math.min(delta, (list.length - 1))
    filtered = removeAtIdx(start,list)
    front_half = filtered[0...end_idx]
    back_half = filtered[end_idx..]
    concat append(item, front_half), back_half


module.exports =
  set: set
  mixWith: mixWith
  toObj: toObj
  applyIf: applyIf
  applyWhen: applyWhen
  applyWhere: applyWhere
  updateWhere: updateWhere
  findWhere: findWhere
  removeWhere: removeWhere
  shuffleAtIdx: shuffleAtIdx


# {mixWith, toObj, applyIf, applyWhen, applyWhere, updateWhere, findWhere, set, removeWhere, shuffleAtIdx} = require 'util'
