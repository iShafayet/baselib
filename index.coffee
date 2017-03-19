
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


