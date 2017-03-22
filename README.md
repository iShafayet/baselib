# baselib
One-stop solution for essential utilities (i.e. async loops, conditions, pub/sub) for nodejs and the browser

## Installation (NodeJS)

```
npm install baselib --save
```

## Require (NodeJS)
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

## Features

* [function `delay`](#delay) (setTimeout with better argument placement)
* function setImmediate (cross-platform shim for nodejs's setImmediate that guarantees execution order)
* class AsyncCondition (helps async workflow significantly. simplifies complex callbacks and if/else conditions)
* function asyncIf (shorthand/sugar for AsyncCondition)
* class AsyncIterator (magical solution for looping asynchronously. Supports generator-esque behavior)
* function asyncWhile (`while` with `async` operation support)
* function asyncForIn (`for ... in ...` (array iteration) with `async` operation support)
* function asyncForOf (`for ... of ...` (object's key/value pair iteration) with `async` operation support)
* class AsyncCollector (very developer-friendly, clean way to handle parallel operations)
* class Publisher (Replacement for nodejs's events with both Series/Sequencial/Blocking and Parallel/Concurrent execution of listeners)
* function shallowCopy (copy an object)
* function deepCopy (copy and object and it's properties recursively)
* function once (converts a function into one that can be only called once)
* function merge (merge two objects into a new one, recursively)


### delay
..

