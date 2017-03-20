
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ AsyncIterator } = baselib

describe 'AsyncIterator', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('AsyncIterator')
    .which.is.a('function')

  it 'General Use Case', (done)->

    testString = ''

    array = [ 'A', 'B', 'C', 'D' ]

    it = new AsyncIterator

    it.generateWith (expectedIndex)-> 
      if expectedIndex < array.length then [ expectedIndex, array[expectedIndex] ] else null

    it.forEach (next, index, item)->
      testString += item
      next()

    it.finally ->
      expect(testString).to.equal('ABCD')
      done()

  it 'General Use Case With Zero Iterations', (done)->

    testString = ''

    array = [ 'A', 'B', 'C', 'D' ]

    it = new AsyncIterator

    it.generateWith (expectedIndex)-> 
      null

    it.forEach (next, index, item)->
      testString += item
      next()

    it.finally ->
      expect(testString).to.equal('')
      done()

  it 'Shimming Array Iteration', (done)->

    testString = ''

    array = [ 'A', 'B', 'C', 'D' ]

    it = new AsyncIterator

    it.generateWith (expectedIndex)-> 
      if expectedIndex < array.length then [ expectedIndex, array[expectedIndex] ] else null

    it.forEach (next, index, item)->
      testString += item
      next()

    it.finally ->
      expect(testString).to.equal('ABCD')
      done()

  it 'Shimming key/value pair of Object Iteration', (done)->

    testString = ''

    obj = 
      a: 'A'
      b: 'B'
      c: 'C'

    it = new AsyncIterator

    array = Object.keys obj
    it.generateWith (expectedIndex)-> 
      if expectedIndex < array.length then [ array[expectedIndex], obj[array[expectedIndex]] ] else null

    it.forEach (next, key, value)->
      testString += key + value
      next()

    it.finally ->
      expect(testString).to.equal('aAbBcC')
      done()

  it 'Shimming while behavior', (done)->

    testString = ''

    it = new AsyncIterator

    i = 0
    it.generateWith (expectedIndex)-> 
      if i < 5
        i += 1
        return []
      else
        null

    it.forEach (next)->
      testString += 'A'
      next()

    it.finally ->
      expect(testString).to.equal('AAAAA')
      done()

