window['baselib'] = {};


/*
  @delay
 */

(function() {
  var AsyncCollector, AsyncCondition, AsyncIterator, Publisher, _setImmediate, _setImmediateShim, asyncForIn, asyncForOf, asyncIf, asyncWhile, deepCopy, delay, merge, once, ref, shallowCopy,
    slice = [].slice,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    hasProp = {}.hasOwnProperty;

  delay = function(timeout, fn) {
    return setTimeout(fn, timeout);
  };

  this.delay = delay;


  /*
    @setImmediate
   */

  ref = (function(_this) {
    return function() {
      var _setImmediate, _setImmediateShim, e, flush, queue;
      try {
        _setImmediate = setImmediate;
      } catch (error) {
        e = error;
        'pass';
      }
      queue = [];
      flush = function() {
        var args, fn, i, item, len, localQueue, results;
        if (queue.length === 0) {
          return;
        }
        localQueue = queue;
        queue = [];
        results = [];
        for (i = 0, len = localQueue.length; i < len; i++) {
          item = localQueue[i];
          fn = item[0], args = item[1];
          results.push(fn.apply({}, args));
        }
        return results;
      };
      _setImmediateShim = function() {
        var args, fn;
        fn = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        queue.push([fn, args]);
        return setTimeout(flush, 0);
      };
      if (!_setImmediate) {
        _setImmediate = _setImmediateShim;
      }
      return [_setImmediate, _setImmediateShim];
    };
  })(this)(), _setImmediate = ref[0], _setImmediateShim = ref[1];

  this.setImmediate = _setImmediate;

  this._setImmediateShim = _setImmediateShim;


  /*
    class @AsyncCondition
   */

  AsyncCondition = (function() {
    function AsyncCondition() {
      this._evalIfReady = bind(this._evalIfReady, this);
      this.truthyCbfn = null;
      this.falsyCbfn = null;
      this.isExpressionSet = false;
      this.isExecuted = false;
      this.finalCbfn = function() {
        return 'pass';
      };
    }

    AsyncCondition.prototype.then = function(truthyCbfn) {
      this.truthyCbfn = truthyCbfn;
      return this;
    };

    AsyncCondition.prototype["else"] = function(falsyCbfn) {
      this.falsyCbfn = falsyCbfn;
      return this;
    };

    AsyncCondition.prototype["eval"] = function(expression1) {
      this.expression = expression1;
      this.isExpressionSet = true;
      _setImmediate(this._evalIfReady);
      return this;
    };

    AsyncCondition.prototype["finally"] = function(finalCbfn) {
      this.finalCbfn = finalCbfn;
      _setImmediate(this._evalIfReady);
      return this;
    };

    AsyncCondition.prototype._evalIfReady = function() {
      if (this.isExpressionSet && !this.isExecuted) {
        this.isExecuted = true;
        if (this.expression) {
          if (this.truthyCbfn) {
            return this.truthyCbfn(this.finalCbfn);
          } else {
            return this.finalCbfn();
          }
        } else {
          if (this.falsyCbfn) {
            return this.falsyCbfn(this.finalCbfn);
          } else {
            return this.finalCbfn();
          }
        }
      }
    };

    return AsyncCondition;

  })();

  this.AsyncCondition = AsyncCondition;


  /*
    @asyncIf
   */

  asyncIf = function(expression) {
    var condition;
    condition = new AsyncCondition;
    condition["eval"](expression);
    return condition;
  };

  this.asyncIf = asyncIf;


  /*
    @shallowCopy
   */

  shallowCopy = function(obj) {
    var flags, key, temp;
    if (obj === null || typeof obj !== "object") {
      return obj;
    }
    if (obj instanceof Date) {
      temp = new Date(obj.getTime());
      return temp;
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global !== null) {
        flags += 'g';
      }
      if (obj.ignoreCase !== null) {
        flags += 'i';
      }
      if (obj.multiline !== null) {
        flags += 'm';
      }
      if (obj.sticky !== null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    temp = new obj.constructor();
    for (key in obj) {
      temp[key] = obj[key];
    }
    return temp;
  };

  this.shallowCopy = shallowCopy;


  /*
    @deepCopy
   */

  deepCopy = function(obj) {
    var flags, key, temp;
    if (obj === null || typeof obj !== "object") {
      return obj;
    }
    if (obj instanceof Date) {
      temp = new Date(obj.getTime());
      return temp;
    }
    if (obj instanceof RegExp) {
      flags = '';
      if (obj.global !== null) {
        flags += 'g';
      }
      if (obj.ignoreCase !== null) {
        flags += 'i';
      }
      if (obj.multiline !== null) {
        flags += 'm';
      }
      if (obj.sticky !== null) {
        flags += 'y';
      }
      return new RegExp(obj.source, flags);
    }
    temp = new obj.constructor();
    for (key in obj) {
      temp[key] = deepCopy(obj[key]);
    }
    return temp;
  };

  this.deepCopy = deepCopy;


  /*
    @once
   */

  once = function(fn) {
    return function() {
      var args;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (fn) {
        fn.apply(this, args);
        return fn = null;
      }
    };
  };

  this.once = once;


  /*
    @merge
   */

  merge = function(a, b) {
    var _, c, key;
    if (a === b) {
      return a;
    }
    if (a === null || typeof a === 'undefined') {
      return b;
    }
    if (b === null || typeof b === 'undefined') {
      return a;
    }
    if ((typeof a) === 'object') {
      if ((typeof b) !== 'object') {
        return a;
      } else {
        if (Array.isArray(a)) {
          if (Array.isArray(b)) {
            return [].concat(a, b);
          } else {
            return a;
          }
        } else {
          if (Array.isArray(b)) {
            return a;
          } else {
            c = {};
            for (key in a) {
              if (!hasProp.call(a, key)) continue;
              _ = a[key];
              if (b.hasOwnProperty(key)) {
                c[key] = merge(a[key], b[key]);
              } else {
                c[key] = a[key];
              }
            }
            for (key in b) {
              if (!hasProp.call(b, key)) continue;
              _ = b[key];
              if (!c.hasOwnProperty(key)) {
                c[key] = b[key];
              }
            }
            return c;
          }
        }
      }
    }
    return a;
  };

  this.merge = merge;


  /*
    @class AsyncIterator
    @purpose Asynchronous iterator supporting generator-esque behavior
   */

  AsyncIterator = (function() {
    function AsyncIterator() {
      this.next = bind(this.next, this);
      this.index = 0;
      this.hasIterationEnded = false;
      _setImmediate(this.next);
    }

    AsyncIterator.prototype.generateWith = function(generatorFn) {
      this.generatorFn = generatorFn;
      return this;
    };

    AsyncIterator.prototype.forEach = function(forEachFn1) {
      this.forEachFn = forEachFn1;
      return this;
    };

    AsyncIterator.prototype.next = function() {
      var args, cb;
      args = this.generatorFn(this.index);
      if (args === null) {
        this.hasIterationEnded = true;
        if (this.finalFn && this.hasIterationEnded) {
          cb = this.finalFn;
          this.finalFn = null;
          return cb();
        }
      } else {
        args = [this.next].concat(args);
        this.index++;
        return this.forEachFn.apply({}, args);
      }
    };

    AsyncIterator.prototype.stop = function() {
      this.hasIterationEnded = true;
      return this["finally"](this.finalFn);
    };

    AsyncIterator.prototype["finally"] = function(finalFn) {
      var cb;
      this.finalFn = finalFn;
      if (this.finalFn && this.hasIterationEnded) {
        cb = this.finalFn;
        this.finalFn = null;
        cb();
      }
      return this;
    };

    return AsyncIterator;

  })();

  this.AsyncIterator = AsyncIterator;


  /*
    @asyncWhile
   */

  asyncWhile = function(evalFn) {
    var it;
    it = new AsyncIterator;
    it.generateWith(function(expectedIndex) {
      if (evalFn()) {
        return [];
      } else {
        return null;
      }
    });
    return it;
  };

  this.asyncWhile = asyncWhile;


  /*
    @asyncForIn
   */

  asyncForIn = function(array, forEachFn) {
    var it;
    if (forEachFn == null) {
      forEachFn = null;
    }
    it = new AsyncIterator;
    it.generateWith(function(expectedIndex) {
      if (expectedIndex < array.length) {
        return [array[expectedIndex], expectedIndex];
      } else {
        return null;
      }
    });
    if (forEachFn) {
      it.forEach(forEachFn);
    }
    return it;
  };

  this.asyncForIn = asyncForIn;


  /*
    @asyncForOf
   */

  asyncForOf = function(object, forEachFn) {
    var array, it;
    if (forEachFn == null) {
      forEachFn = null;
    }
    array = Object.keys(object);
    it = new AsyncIterator;
    it.generateWith(function(expectedIndex) {
      if (expectedIndex < array.length) {
        return [array[expectedIndex], object[array[expectedIndex]]];
      } else {
        return null;
      }
    });
    if (forEachFn) {
      it.forEach(forEachFn);
    }
    return it;
  };

  this.asyncForOf = asyncForOf;


  /*
    @class AsyncCollector
    @purpose Asynchronous counter and data collector
   */

  AsyncCollector = (function() {
    function AsyncCollector(totalToCollect) {
      this.totalToCollect = totalToCollect;
      this.count = 0;
      this.collection = {};
      _setImmediate((function(_this) {
        return function() {
          return _this._finalizeIfDone();
        };
      })(this));
    }

    AsyncCollector.prototype._finalizeIfDone = function() {
      if (this.totalToCollect === this.count) {
        if (this.finallyFn) {
          _setImmediate(this.finallyFn, this.collection);
        }
        return this.finallyFn = null;
      }
    };

    AsyncCollector.prototype.collect = function(key, value) {
      if (key == null) {
        key = null;
      }
      if (value == null) {
        value = null;
      }
      if (this.totalToCollect !== this.count) {
        if (key) {
          this.collection[key] = value;
        }
        this.count += 1;
      }
      return this._finalizeIfDone();
    };

    AsyncCollector.prototype["finally"] = function(finallyFn) {
      this.finallyFn = finallyFn;
      return this;
    };

    return AsyncCollector;

  })();

  this.AsyncCollector = AsyncCollector;


  /*
    @class Publisher
    @purpose Lightweight and optionally sequencially executed alternative to nodejs EventEmitters
   */

  Publisher = (function() {
    function Publisher() {
      this.subscriberFnList = [];
    }

    Publisher.prototype.publishInParallel = function() {
      var col, data, doneFn;
      data = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      col = new AsyncCollector(this.subscriberFnList.length);
      col["finally"]((function(_this) {
        return function() {
          if (_this.finalCbfn) {
            return _this.finalCbfn();
          }
        };
      })(this));
      doneFn = function() {
        return col.collect();
      };
      _setImmediate((function(_this) {
        return function() {
          var args, fn, i, len, ref1, results;
          ref1 = _this.subscriberFnList;
          results = [];
          for (i = 0, len = ref1.length; i < len; i++) {
            fn = ref1[i];
            args = [doneFn].concat(data);
            results.push(fn.apply({}, args));
          }
          return results;
        };
      })(this));
      return this;
    };

    Publisher.prototype.publishInSeries = function() {
      var array, data, it;
      data = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      it = new AsyncIterator;
      array = this.subscriberFnList;
      it.generateWith(function(expectedIndex) {
        if (expectedIndex < array.length) {
          return [expectedIndex, array[expectedIndex]];
        } else {
          return null;
        }
      });
      it.forEach(function(next, index, fn) {
        var args, stopFn;
        stopFn = function() {
          return it.stop();
        };
        args = [next, stopFn].concat(data);
        return fn.apply({}, args);
      });
      it["finally"]((function(_this) {
        return function() {
          if (_this.finalCbfn) {
            return _this.finalCbfn();
          }
        };
      })(this));
      return this;
    };

    Publisher.prototype["finally"] = function(finalCbfn) {
      this.finalCbfn = finalCbfn;
      return this;
    };

    Publisher.prototype.subscribe = function(fn) {
      this.subscriberFnList.push(fn);
      return this;
    };

    Publisher.prototype.unsubscribe = function(fn) {
      var index;
      if ((index = this.subscriberFnList.indexOf(fn)) > -1) {
        this.subscriberFnList.splice(index, 1);
      }
      return this;
    };

    return Publisher;

  })();

  this.Publisher = Publisher;

}).call(window['baselib']);

