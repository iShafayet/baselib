
###
  @delay
###

delay = (timeout, fn)->
  setTimeout fn, timeout

@delay = delay

###
  @setImmediate
###

try
  _setImmediate = setImmediate
catch e
  'pass'

_setImmediateShim = (fn, args...)->
  setTimeout ->
    fn.apply {}, args
  , 0

unless _setImmediate
  _setImmediate = _setImmediateShim

@setImmediate = _setImmediate
@_setImmediateShim = _setImmediateShim