
###
  @delay
###

delay = (timeout, fn)->
  setTimeout fn, timeout

@delay = delay


###
  @setImmediate
###

[ _setImmediate, _setImmediateShim ] = do =>

  try
    _setImmediate = setImmediate
  catch e
    'pass'

  queue = []

  flush = ->
    return if queue.length is 0
    localQueue = queue
    queue = []
    for item in localQueue
      [fn, args] = item
      fn.apply {}, args

  _setImmediateShim = (fn, args...)->
    queue.push [ fn, args ]
    setTimeout flush, 0

  unless _setImmediate
    _setImmediate = _setImmediateShim

  return [ _setImmediate, _setImmediateShim ]

@setImmediate = _setImmediate
@_setImmediateShim = _setImmediateShim


###
  class @AsyncCondition
###

class AsyncCondition

  constructor: ->
    @truthyCbfn = null
    @falsyCbfn = null
    @isExpressionSet = false
    @isExecuted = false
    @finalCbfn = -> 'pass'

  then: (@truthyCbfn)->
    return @

  else: (@falsyCbfn)->
    return @

  eval: (@expression)->
    @isExpressionSet = true
    _setImmediate @_evalIfReady
    return @

  finally: (@finalCbfn)->
    _setImmediate @_evalIfReady
    return @    
  
  _evalIfReady: =>
    if @isExpressionSet and not @isExecuted
      @isExecuted = true
      if @expression
        if @truthyCbfn
          @truthyCbfn @finalCbfn
        else
          @finalCbfn()
      else
        if @falsyCbfn
          @falsyCbfn @finalCbfn
        else
          @finalCbfn()

@AsyncCondition = AsyncCondition


###
  @asyncIf
###

asyncIf = (expression)->
  condition = new AsyncCondition
  condition.eval expression
  return condition

@asyncIf = asyncIf


###
  @shallowCopy
###

shallowCopy = (obj)->
  return obj if obj is null or typeof (obj) isnt "object"
  if obj instanceof Date
    temp = new Date(obj.getTime())
    return temp
  if obj instanceof RegExp
    flags = ''
    if obj.global != null
      flags += 'g'
    if obj.ignoreCase != null
      flags += 'i'
    if obj.multiline != null
      flags += 'm'
    if obj.sticky != null
      flags += 'y'
    return new RegExp(obj.source, flags)
  temp = new obj.constructor()
  for key of obj
    temp[key] = obj[key]
  return temp

@shallowCopy = shallowCopy


###
  @deepCopy
###

deepCopy = (obj)->
  return obj if obj is null or typeof (obj) isnt "object"
  if obj instanceof Date
    temp = new Date(obj.getTime())
    return temp
  if obj instanceof RegExp
    flags = ''
    if obj.global != null
      flags += 'g'
    if obj.ignoreCase != null
      flags += 'i'
    if obj.multiline != null
      flags += 'm'
    if obj.sticky != null
      flags += 'y'
    return new RegExp(obj.source, flags)
  temp = new obj.constructor()
  for key of obj
    temp[key] = deepCopy obj[key]
  return temp

@deepCopy = deepCopy


###
  @once
###

once = (fn)->
  return (args...)->
    if fn
      fn.apply this, args
      fn = null

@once = once


###
  @merge
###

merge = (a, b)->
  if a is b
    return a
  if a is null or typeof a is 'undefined'
    return b
  if b is null or typeof b is 'undefined'
    return a
  if (typeof a) is 'object'
    if (typeof b) isnt 'object'
      return a
    else
      if Array.isArray a
        if Array.isArray b
          return [].concat a, b
        else
          return a
      else
        if Array.isArray b
          return a
        else
          c = {}
          for own key, _ of a
            if b.hasOwnProperty key
              c[key] = merge a[key], b[key]
            else
              c[key] = a[key]
          for own key, _ of b
            unless c.hasOwnProperty key
              c[key] = b[key]
          return c
  return a

@merge = merge


###
  @class AsyncIterator
  @purpose Asynchronous iterator supporting generator-esque behavior
###

class AsyncIterator

  constructor: ()->
    @index = 0
    @hasIterationEnded = false
    _setImmediate @next
    
  generateWith: (@generatorFn)->
    return @

  forEach: (@forEachFn)->
    return @

  next: ()=>
    args = @generatorFn @index
    if args is null
      @hasIterationEnded = true
      if @finalFn and @hasIterationEnded
        cb = @finalFn
        @finalFn = null
        cb()
    else
      args = [ @next ].concat args
      @index++
      @forEachFn.apply {}, args

  finally: (@finalFn)->
    if @finalFn and @hasIterationEnded
      cb = @finalFn
      @finalFn = null
      cb()
    return @

@AsyncIterator = AsyncIterator


###
  @asyncWhile
###

asyncWhile = (evalFn)->

  it = new AsyncIterator

  it.generateWith (expectedIndex)-> 
    if evalFn() then [] else null

  return it

@asyncWhile = asyncWhile


###
  @asyncForIn
###

asyncForIn = (array, forEachFn = null)->

  it = new AsyncIterator

  it.generateWith (expectedIndex)-> 
    if expectedIndex < array.length then [ expectedIndex, array[expectedIndex] ] else null

  if forEachFn
    it.forEach forEachFn

  return it

@asyncForIn = asyncForIn


###
  @asyncForOf
###

asyncForOf = (object, forEachFn = null)->

  array = Object.keys object

  it = new AsyncIterator

  it.generateWith (expectedIndex)-> 
    if expectedIndex < array.length then [ array[expectedIndex], object[array[expectedIndex]] ] else null

  if forEachFn
    it.forEach forEachFn

  return it

@asyncForOf = asyncForOf


###
  @class AsyncCollector
  @purpose Asynchronous counter and data collector
###

class AsyncCollector

  constructor: (@totalToCollect)->
    @count = 0
    @collection = {}
    _setImmediate => @_finalizeIfDone()

  _finalizeIfDone: ->
    if @totalToCollect is @count
      _setImmediate @finallyFn, @collection if @finallyFn
      @finallyFn = null

  collect: (key = null, value = null)->
    unless @totalToCollect is @count
      if key
        @collection[key] = value
      @count += 1
    @_finalizeIfDone()

  finally: (@finallyFn)->
    return @

@AsyncCollector = AsyncCollector



