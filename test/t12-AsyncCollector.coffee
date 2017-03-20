
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ AsyncCollector } = baselib

describe 'AsyncCollector', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('AsyncCollector')
    .which.is.a('function')

  it 'General Use Case', (done)->

    testString = ''

    col = new AsyncCollector 3

    baselib.delay 10, -> 
      testString += 'A'
      col.collect 'a', 1

    baselib.delay 90, -> 
      testString += 'B'
      col.collect 'b', 2

    baselib.delay 180, -> 
      testString += 'C'
      col.collect 'c', 3

    col.finally (collection)->
      expect(testString).to.equal('ABC')
      expect(collection).to.deep.equal({ a: 1, b: 2, c: 3})
      done()

  it 'More than expected collect() calls', (done)->

    testString = ''

    col = new AsyncCollector 3

    baselib.delay 10, -> 
      testString += 'A'
      col.collect 'a', 1

    baselib.delay 90, -> 
      testString += 'B'
      col.collect 'b', 2

    baselib.delay 180, -> 
      testString += 'C'
      col.collect 'c', 3

    baselib.delay 270, -> 
      testString += 'D'
      col.collect 'd', 4

    col.finally (collection)->
      expect(testString).to.equal('ABC')
      expect(collection).to.deep.equal({ a: 1, b: 2, c: 3})
      baselib.delay 500, ->
        done()

  it 'Zero items to collect', (done)->

    testString = ''

    col = new AsyncCollector 0

    baselib.delay 30, -> 
      testString += 'A'
      col.collect 'a', 1

    baselib.delay 90, -> 
      testString += 'B'
      col.collect 'b', 2

    baselib.delay 180, -> 
      testString += 'C'
      col.collect 'c', 3

    col.finally (collection)->
      expect(testString).to.equal('')
      expect(collection).to.deep.equal({})
      baselib.delay 200, ->
        done()


