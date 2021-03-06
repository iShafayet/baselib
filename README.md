# baselib
One-stop solution for essential utilities (i.e. async loops, conditions, pub/sub) for nodejs and the browser.

[![NPM](https://nodei.co/npm/baselib.png?compact=true)](https://npmjs.org/package/baselib)

**N/B:** The code/examples in this file are in coffee-script. <!-- [Click here for the JavaScript Version](README-js.md) (coming soon)--> Javascript examples are coming soon.

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


<!-- Browser Area Start -->
# Installation (Browser)

[Download the latest build](https://github.com/iShafayet/baselib/blob/master/dist/browser/baselib-0.1.0.js) and put it in your application.

```html
<script type="text/javascript" src="baselib-0.1.0.js"></script>
```
<!-- Browser Area End -->

# Features

* [function `delay`](#delay) (setTimeout with better argument placement)
* [function `setImmediate`](#setimmediate) (Cross-platform shim for nodejs's setImmediate that guarantees execution order)
* [class `AsyncCondition`](#asynccondition) (Helps async workflow significantly. Simplifies complex callbacks and if/else conditions)
* [function `asyncIf`](#asyncif) (Shorthand/sugar for AsyncCondition)
* [class `AsyncIterator`](#asynciterator) (Very flexible and *clean* solution for looping asynchronously. Supports generator-esque behavior)
* [function `asyncWhile`](#asyncwhile) (`while` with asynchronous operation support)
* [function `asyncForIn`](#asyncforin) (`for ... in ...` (array iteration) with asynchronous operation support)
* [function `asyncForOf`](#asyncforof) (`for ... of ...` (object's key/value pair iteration) with asynchronous operation support)
* [class `AsyncCollector`](#asynccollector) (Very developer-friendly, clean way to handle parallel operations that converge)
* [class `Publisher`](#publisher) (Replacement for nodejs's events with both Series/Sequencial/Blocking and Parallel/Concurrent execution of listeners)
* [function `shallowCopy`](#shallowcopy) (Copy all properties of an object)
* [function `deepCopy`](#deepcopy) (Copy and object and it's properties recursively)
* [function `once`](#once) (Converts a function into one that can be only called once)
* [function `merge`](#merge) (Merge two objects into a new one, recursively)


## delay
`delay timeToWaitInMilliseconds, functionToCall`

**Example:**
```coffee-script
console.log 'Do Something'
delay 2000, ->
  console.log 'Do something after 2 seconds'
```

## setImmediate
`setImmediate functionToCall, [argument1, [argument2, ... , [argumentN]]]`

**Example:**
```coffee-script
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

the `eval` method takes any value which is immediately evaluated to find out whether it's truthy or falsy.

### `AsyncCondition#then functionToCall`

the `then` method takes a function as a parameter. The provided function is invoked if the value provided to `eval` is truthy. `functionToCall` will receive a single parameter which is a function. Call it to signal the end of operation.

### `AsyncCondition#else functionToCall`

the `else` method takes a function as a parameter. The provided function is invoked if the value provided to `eval` is falsy. `functionToCall` will receive a single parameter which is a function. Call it to signal the end of operation.

### `AsyncCondition#finally functionToCall`

the `finally()` method takes a function as a parameter. The provided function is invoked only after the operation of either `then()` or `else()` has been finished.

**Example:**

```coffee-script
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

**Example:**

```coffee-script
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

### `new AsyncIterator`

Returns a new AsyncCondition object. It's methods are chainable. So you don't have to name the object.

### `AsyncIterator#generateWith fn`

`generateWith` takes a function as the only parameter. The provided function is invoked every time we need decide whether to do another iteration or not. The provided function may return an array (which can be empty) which will be passed on to the callbacks of the `forEach()` method. If the provided function returns `null` then it is assumed that there can be no more iterations and the callback for the `finally()` method is invoked.

### `AsyncIterator#forEach fn`

`forEach` takes a function as the only parameter `fn`. `fn` is called every time there is anything iterable. `fn` will receive a function `next` as the first parameter which must be called to signal the end of an operation. Any parameters returned by `generateWith` is sent to the `fn`.

### `AsyncIterator#next`

`next` iterates to the next item.

### `AsyncIterator#stop`

`stop` stops the iteration. similar to `break` in while loops.

### `AsyncIterator#finally fn`

the `finally()` method takes a function as a parameter. The provided function (`fn`) is invoked only after iteration is complete. (i.e. `generateWith` returned `null` or `stop` was called)

**Example:** (In the example below, we actually iterate over an array and do some asynchronous operations)

```coffee-script
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

`asyncWhile` let's you do asynchronous operations on a loop while a certain condition is true. (Just like the traditional `while` syntax)

Sync Code:

```coffee-script
console.log "Before loop"
i = 0
while i < 10
  console.log "In loop"
  i++
console.log "After loop"
```

Same thing but asynchronously

```coffee-script
console.log "Before loop"
i = 0
asyncWhile -> i < 10
.forEach (next)->
  console.log "In loop"
  i += 1
  next()
.finally ->
  console.log "After loop"
```

## asyncForIn

`asyncForIn` let's you loop through each element of an array. (Just like the traditional `for ... in ...`  syntax)

Sync Code:

```coffee-script
array = [ 'A', 'B', 'C' ]
console.log "Before loop"
for item, index in array
  console.log "In loop. Item #{item}. Index #{index}"
console.log "After loop"
```

Same thing but asynchronously

```coffee-script
array = [ 'A', 'B', 'C' ]
console.log "Before loop"
asyncForIn array
.forEach (next, item, index)->
  console.log "In loop. Item #{item}. Index #{index}"
  next()
.finally ->
  console.log "After loop"
```

## asyncForOf
`asyncForOf` let's you loop through each key/value pair of an object/map. (Just like the traditional `for ... of ...`  syntax)

Sync Code:

```coffee-script
object = { a: 1, b: 2 , c: 3 }
console.log "Before loop"
for own key, value of array
  console.log "In loop. Key #{key}. Value #{value}"
console.log "After loop"
```

Same thing but asynchronously

```coffee-script
object = { a: 1, b: 2 , c: 3 }
console.log "Before loop"
asyncForOf array
.forEach (next, key, value)->
  console.log "In loop. Key #{key}. Value #{value}"
  next()
.finally ->
  console.log "After loop"
```

## AsyncCollector
`AsyncCollector` class is a rather innovative way to handle multiple asynchronous operation that converge to a single callback. It has a built in mechanism to collect arbitrary data.

### `new AsyncCollector numberOfParallelOperations`

Returns a new AsyncCollector object. It's methods are chainable. So you don't have to name the object. It takes a single mandatory parameter. The number of parallel operations you intend to do.

### `AsyncCollector#collect [key, value]`

`collect` marks 1 operation as done (i.e. increments `numberOfOperationsDone`). The number of operations left is computed by `numberOfParallelOperations - numberOfOperationsDone`. It optionally takes a `key` and a `value` which gets stored in an object which is passed to the `fn` of `finally`


### `AsyncIterator#finally fn`

the `finally()` method takes a function as a parameter. The provided function (`fn`) is invoked only after iteration is complete. As a parameter, it will receive as a parameter the object in which the key/value pairs provided by `collect` method is collected.

**Example:**

```coffee-script
col = new AsyncCollector 3

baselib.delay 10, -> 
  col.collect 'a', 1

baselib.delay 90, -> 
  col.collect 'b', 2

baselib.delay 180, -> 
  col.collect 'c', 3

col.finally (collection)->
  console.log collection # prints { a: 1, b: 2, c: 3}
```

## Publisher
`Publisher` class is a lightweight alternative to NodeJS's EventEmitters. It has the option to publish data either *sequentially* or *parallely* allowing a much greater flow control. On sequencial operations, a subscriber can even choose to stop the propagation altogether, much like the `Event#stopPropagation` in DOM.

### `new Publisher`

Returns a new Publisher object. It's methods are chainable. So you don't have to name the object.

### `Publisher#subscribe fn`

the `subscribe()` method takes a function as a parameter. The provided function (`fn`) is put in a queue and called with the data provided by `Publisher#publishInSeries` or `Publisher#publishInParallel`. 

For `Publisher#publishInSeries`, the fn's signature will be like `fn = (next, stop, args...)->`. where `next` is a function that must be called to signal the end of operation. `stop` can be called to stop the propagation of the data altogether (depriving the subsequent subscribers). These two parameters are followed by any data published.

For `Publisher#publishInParallel`, the fn's signature will be like `fn = (next, args...)->`. where `next` is a function that must be called to signal the end of operation. There is no `stop` operation as all the subscribers are notified in parallel. The `next` parameter is followed by any data published.

### `Publisher#unsubscribe fn`

The `unsubscribe()` method takes a function as a parameter. If `fn` is already in queue it will remove it. Otherwise it has no effect

### `Publisher#publishInSeries data...`

The `publishInSeries` method lets you publish your data to all the subscribers one by one. One subscriber must call the `next` function in order to propagate data to the next subscriber. The data you provided will be passed on to the subscribers.

### `Publisher#publishInParallel data...`

The `publishInParallel` method lets you publish your data to all the subscribers parallely. The data you provided will be passed on to the subscribers.

### `AsyncIterator#finally fn`

the `finally()` method takes a function as a parameter. The provided function (`fn`) is invoked only after either all the subscriber has called the `next` function or at least one has called the `stop` function.

**Example:**

```coffee-script
testString = ''

pub = new Publisher

pub.subscribe (next, stop, arg1, arg2)->
  testString += 'A' + arg1 + arg2
  next()

pub.subscribe (next, stop, arg1, arg2)->
  testString += 'B' + arg1 + arg2
  stop()

pub.subscribe (next, stop, arg1, arg2)->
  testString += 'C'
  next()

pub.finally ->
  console.log testString # prints 'Aa1Ba1'
  done()

baselib.delay 50, ->
  pub.publishInSeries 'a', 1
```

## shallowCopy
`shallowCopy anyValue`

shallowCopy copies all the properties/items in an object/array to a new one. If given a non-object / non-array value (i.e. Number, String etc), the value is returned.

It handles Regex and Date objects as well. Also, calls the constructor for user made classes and copies the properties. So, if there are no hidden properties, user made class instances should be copied reasonably reliably.

**Example:**

```
testObject = {
  a: 3
  b:
    ba: 4
    bb: 5
  c: [
    1
    2
    {
      r: 3
      x: 4
    }
  ]
  d: new Date
}
copiedObject = shallowCopy testObject
console.log testObject is copiedObject # false
console.log testObject.b is copiedObject.b # true
```

## deepCopy
`deepCopy anyValue`

deepCopy copies all the properties/items in an object/array to a new one **recursively**. If given a non-object / non-array value (i.e. Number, String etc), the value is returned.

It handles Regex and Date objects as well. Also, calls the constructor for user made classes and copies the properties. So, if there are no hidden properties, user made class instances should be copied reasonably reliably.

**Example:**

```
testObject = {
  a: 3
  b:
    ba: 4
    bb: 5
  c: [
    1
    2
    {
      r: 3
      x: 4
    }
  ]
  d: new Date
}
copiedObject = shallowCopy testObject
console.log testObject is copiedObject # false
console.log testObject.b is copiedObject.b # false
```

## once
`once fn`

`once` returns a function that can be called only once. Effectively you could say it converts a function so that it can be called only once. It passes on the execution context (a.k.a. `this`) reliably.

**Example:**

```
testInteger = 0

fn = -> testInteger += 1

oFn = once fn

oFn()
oFn()
oFn()

console.log testInteger # prints 1
```

## merge
`merge value1, value2`

`merge` as the name suggests, merges two values (most usefully objects and arrays) into one. `merge` makes sure that the original values `value1` and `value2` are not altered in any way. However it does not ensure that the tree is fully unique. In order to get a guaranteed unique copy perform `deepCopy merge value1, value2`

**Example:**

```
    a = { a: 1, c: { d: 4, e: 5, k: [ 1, 4 ] } }
    b = { b: 2, c: { d: 4, f: 6, k: [ 2 ] } }
    m = merge a, b
   
    console.log m # prints { a: 1, b: 2, c: { d: 4, e: 5, f: 6, k: [ 1, 4, 2 ] } }
```


