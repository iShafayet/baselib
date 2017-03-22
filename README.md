# baselib 0.0.x
One-stop solution for essential utilities (i.e. async loops, conditions, pub/sub) for nodejs and the browser.

**N/B:** The code/examples in this file are in coffee-script. [Click here for the JavaScript Version](README-js.md) (coming soon)

# Installation (NodeJS)

```
npm install baselib --save
```

# Require (NodeJS)
```
{
  delay
  setImmediate
  AsyncCondition
  asyncIf
  AsyncIterator
  asyncWhile
  asyncForIn
  asyncForOf
  AsyncCollector
  Publisher
  shallowCopy
  deepCopy
  once
  merge
} = require 'baselib'
```

# Features

* [function `delay`](#delay) (setTimeout with better argument placement)
* [function `setImmediate`](#setimmediate) (cross-platform shim for nodejs's setImmediate that guarantees execution order)
* [class `AsyncCondition`](#asynccondition) (helps async workflow significantly. simplifies complex callbacks and if/else conditions)
* [function `asyncIf`](#asyncif) (shorthand/sugar for AsyncCondition)
* [class `AsyncIterator`](#asynciterator) (magical solution for looping asynchronously. Supports generator-esque behavior)
* [function `asyncWhile`](#asyncwhile) (`while` with `async` operation support)
* [function `asyncForIn`](#asyncforin) (`for ... in ...` (array iteration) with `async` operation support)
* [function `asyncForOf`](#asyncforof) (`for ... of ...` (object's key/value pair iteration) with `async` operation support)
* [class `AsyncCollector`](#asynccollector) (very developer-friendly, clean way to handle parallel operations)
* [class `Publisher`](#publisher) (Replacement for nodejs's events with both Series/Sequencial/Blocking and Parallel/Concurrent execution of listeners)
* [function `shallowCopy`](#shallowcopy) (copy an object)
* [function `deepCopy`](#deepcopy) (copy and object and it's properties recursively)
* [function `once`](#once) (converts a function into one that can be only called once)
* [function `merge`](#merge) (merge two objects into a new one, recursively)


## delay
`delay timeToWaitInMilliseconds, functionToCall`

example:
```
console.log 'Do Something'
delay 2000, ->
  console.log 'Do something after 2 seconds'
```

## setImmediate
`setImmediate functionToCall, [argument1, [argument2, ... , [argumentN]]]`

example:
```
setImmediate ->
  console.log "I'll be executed second"
setImmediate (someValue)->
  console.log "I'll be executed third and here is #{someValue}"
console.log "I'll be executed first"
```

## AsyncCondition
AsyncCondition class enables you to manage your asynchronous code much more effectively while providing a reusable structure.

### `new AsyncCondition`

Returns a new AsyncCondition object. It's methods are chainable. So you don't have to name the object.

### `AsyncCondition#eval expression`

the `eval()` method takes any value which is immediately evaluated to find out whether it's truthy or falsy.

### AsyncCondition#then functionToCall

the `then()` method takes a function as a parameter. The provided function is invoked if the value provided to `eval()` is truthy. functionToCall will receive a single parameter which is a function. Call it to signal the end of operation.

### `AsyncCondition#else functionToCall`

the `else()` method takes a function as a parameter. The provided function is invoked if the value provided to `eval()` is falsy. functionToCall will receive a single parameter which is a function. Call it to signal the end of operation.

### `AsyncCondition#finally functionToCall`

the `finally()` method takes a function as a parameter. The provided function is invoked only after the operation of either `then()` or `else()` has been finished.

example:

```
c1 = new AsyncCondition
c1.eval (typeof 1 is 'number')
c1.then (cbfn)->
  console.log 'Got a number'
  delay 100, ->
    console.log 'Delayed for the sake of example'
    cbfn() # signal the end of operation
c1.else (cbfn)->
  console.log 'Did not get a number'
  cbfn()
c1.finally ->
  console.log 'I will be called anyway when the `cbfn` of `then` is invoked'
```

## asyncIf

A shorthand for AsyncCondition

`asyncIf expression` (returns an AsyncCondition instance who's `eval()` has already been called.)

example: (the same scenario as above)

```
asyncIf (typeof 1 is 'number')
.then (cbfn)->
  console.log 'Got a number'
  delay 100, ->
    console.log 'Delayed for the sake of example'
    cbfn() # signal the end of operation
.else (cbfn)->
  console.log 'Did not get a number'
  cbfn()
.finally ->
  console.log 'I will be called anyway when the `cbfn` of `then` is invoked'
```

## AsyncIterator
`AsyncIterator` class provides a low level interface for running asynchronous operations in loops. It is very very generalized and so it can be used to implement almost any kind of looping behavior with minimal effort. For example, baselib comes with three functions that can effectively replace the synchronous counterparts. Namely, `asyncWhile` replacing `while`, `asyncForIn` replacing `for ... in ...` (array iteration), `asyncForOf` replacing `for ... of ...` (object's key/value pair iteration). All these functions are based on `AsyncIterator`.

**N/B:** AsyncIterator class is designed for maximum configurability. `asyncWhile`, `asyncForOf` and `asyncForIn` is much better suited for common use cases.

## `new AsyncIterator`

Returns a new AsyncCondition object. It's methods are chainable. So you don't have to name the object.

## `AsyncIterator#generateWith fn`

`generateWith` takes a function as the only parameter. The provided function is invoked every time we need decide whether to do another iteration or not. The provided function may return an array (which can be empty) which will be passed on to the callbacks of the `forEach()` method. If the provided function returns `null` then it is assumed that there can be no more iterations and the callback for the `finally()` method is invoked.

## `AsyncIterator#forEach fn`

`forEach` takes a function as the only parameter `fn`. `fn` is called every time there is anything iterable. `fn` will receive a function `next` as the first parameter which must be called to signal the end of an operation. Any parameters returned by `generateWith` is sent to the `fn`.

## `AsyncIterator#next`

`next` iterates to the next item.

## `AsyncIterator#stop`

`stop` stops the iteration. similar to `break` in while loops.

## `AsyncIterator#finally fn`

the `finally()` method takes a function as a parameter. The provided function (`fn`) is invoked only after iteration is complete. (i.e. `generateWith` returned `null` or `stop` was called)

Example: (In the example below, we actually iterate over an array and do some asynchronous operations)

```
testString = ''

array = [ 'A', 'B', 'C', 'D' ]

it = new AsyncIterator

it.generateWith (expectedIndex)-> 
  if expectedIndex < array.length then [ expectedIndex, array[expectedIndex] ] else null

it.forEach (next, index, item)->
  delay 10, ->
    testString += item + index
    next()

it.finally ->
  console.log testString # prints 'A0B1C2D3'
  done()
```



## asyncWhile
...

## asyncForIn
...

## asyncForOf
...

## AsyncCollector
...

### Publisher
...

### shallowCopy
...

### deepCopy
...

### once
...

### merge
...


