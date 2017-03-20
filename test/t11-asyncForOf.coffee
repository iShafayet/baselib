
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ asyncForOf, AsyncIterator } = baselib

describe 'asyncForOf', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('asyncForOf')
    .which.is.a('function')

  it 'asyncForOf maps to AsyncIterator', ->

    it = asyncForOf { a: 1, b: 2 , c: 3 }
    expect(it).to.be.an.instanceOf(AsyncIterator)

  it 'General Use Case', (done)->

    object = { a: 1, b: 2 , c: 3 }
    testString = ''

    asyncForOf object
    .forEach (next, key, value )->
      testString += key + value
      next()
    .finally ->
      expect(testString).to.equal('a1b2c3')
      done()

  it 'Alternative Form', (done)->

    object = { a: 4, b: 5 , c: 6 }
    testString = ''

    asyncForOf object, (next, key, value )->
      testString += key + value
      next()
    .finally ->
      expect(testString).to.equal('a4b5c6')
      done()

  it 'Zero Properties', (done)->

    object = {}
    testString = ''

    asyncForOf object, (next, key, value )->
      testString += key + value
      next()
    .finally ->
      expect(testString).to.equal('')
      done()