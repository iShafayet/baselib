
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ asyncWhile, AsyncIterator } = baselib

describe 'asyncWhile', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('asyncWhile')
    .which.is.a('function')

  it 'asyncWhile maps to AsyncIterator', ->

    it = asyncWhile -> 'TEST'
    expect(it).to.be.an.instanceOf(AsyncIterator)

  it 'General Use Case', ->

    testString = ''

    i = 0
    asyncWhile -> i < 10
    .forEach (next)->
      i += 1
      testString += 'A'
      next()
    .finally ->
      expect(testString).to.equal('AAAAAAAAAA')
      done()


  it 'General Use Case with Zero Iteration', ->

    testString = ''

    i = 0
    asyncWhile -> i < 0
    .forEach (next)->
      i += 1
      testString += 'A'
      next()
    .finally ->
      expect(testString).to.equal('AAAAAAAAAA')
      done()

