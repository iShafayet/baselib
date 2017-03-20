
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ asyncForIn, AsyncIterator } = baselib

describe 'asyncForIn', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('asyncForIn')
    .which.is.a('function')

  it 'asyncForIn maps to AsyncIterator', ->

    it = asyncForIn [ 1, 2, 3, 4 ]
    expect(it).to.be.an.instanceOf(AsyncIterator)

  it 'General Use Case', ->

    array = [ 'A', 'B', 'C', 'D' ]

    asyncForIn array
    .forEach (next, index, item)->
      testString += item
      next()
    .finally ->
      expect(testString).to.equal('ABCD')
      done()

  it 'Alternative Form', ->

    array = [ 'A', 'B', 'C', 'D' ]

    asyncForIn array, (next, index, item)->
      testString += item
      next()
    .finally ->
      expect(testString).to.equal('ABCD')
      done()

  it 'Zero Elements', ->

    array = []

    asyncForIn array, (next, index, item)->
      testString += item
      next()
    .finally ->
      expect(testString).to.equal('')
      done()
