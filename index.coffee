
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