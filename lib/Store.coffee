# {curry,nAry,unary,binary,arity,invoker,useWith,use,each,forEach,clone,isEmpty,prepend,cons,head,car,first,last,tail,cdr,isAtom,append,push,merge,concat,identity,I,times,repeatN,compose,pipe,sequence,flip,lPartial,applyLeft,rPartial,applyRight,memoize,once,wrap,construct,fork,foldl,reduce,foldr,reduceRight,unfoldr,map,mapObj,size,filter,reject,takeWhile,take,skipUntil,skip,drop,find,findIndex,findLast,findLastIndex,all,every,any,some,indexOf,lastIndexOf,contains,containsWith,uniq,isSet,uniqWith,pluck,flatten,zipWith,zip,xprodWith,xprod,reverse,range,join,slice,remove,insert,nth,comparator,sort,partition,groupBy,tap,K,eq,prop,get,func,props,always,constant,keys,keysIn,values,valuesIn,pick,omit,pickWith,pickAll,mixin,eqProps,where,installTo,alwaysZero,alwaysFalse,alwaysTrue,allPredicates,anyPredicates,add,multiply,subtract,subtractN,divide,divideBy,modulo,moduloBy,sum,product,lt,lte,gt,gte,max,maxWith,minWith,min,substring,substringFrom,substringTo,charAt,charCodeAt,match,strIndexOf,strLastIndexOf,toUpperCase,toLowerCase,split,pathWith,pathOn,path,project,propEq,union,unionWith,difference,differenceWith,intersection,intersectionWith,sortBy,countBy} = require 'ramda'
{lPartial, push, compose, concat, append, nth, curry, map, where, find, reject, flip, mixin} = require 'ramda'
{updateWhere, findWhere} = require "./utils.coffee"

{mustBeMap, mustBeArray, mustBeFunction} = require "./Validation.coffee"

{uniqueId, cloneDeep} = require 'lodash'

addUniqueId = (obj)-> mixin obj, {_id: uniqueId()}

class Store extends require("./Ref.coffee").Ref
    constructor: ->
        self = this

        super([])

        setState_array_only = mustBeArray(self.setState)

        _transform = mustBeFunction (fn)->
            setState_array_only(fn(self.getState()))

        _add = mustBeMap (item)->
            _item = addUniqueId(item)
            _transform(lPartial(push, _item))
            return cloneDeep(_item)

        _update = (spec, key, val)-> _transform(updateWhere(spec,key,val))

        _remove = mustBeFunction compose(_transform,reject)

        _removeWhere = mustBeMap compose(_remove,where)

        _find = mustBeFunction (fn)-> find(fn, self.getState())

        _findWhere = mustBeMap (spec)-> findWhere(spec, self.getState())

        @update = _update
        @add = _add
        @remove = _remove
        @removeWhere = _removeWhere
        @findWhere = _findWhere
        @find = _find

module.exports.Store = Store
