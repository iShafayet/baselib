
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

describe 'setImmediate', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('setImmediate')
    .which.is.a('function')

    expect(baselib)
    .to.have.property('_setImmediateShim')
    .which.is.a('function')

  it 'General Use Case', (done)->

    testCounter = 0 

    baselib.setImmediate ->
      done() if testCounter is 1

    testCounter += 1

  it 'Execution Order is Correct for setImmediate', (done)->

    testString = ''

    fn0 = -> testString += '0'
    fn2 = ->
      testString += '2'
      fn3()
    fn1 = -> testString += '1'
    fn3 = -> testString += '3'
    fn4 = ->
      testString += '4'
      baselib.setImmediate fn6
    fn5 = -> testString += '5'
    fn6 = -> testString += '6'

    baselib.setImmediate fn1
    baselib.setImmediate fn2
    baselib.setImmediate fn4
    baselib.setImmediate fn5
    fn0()

    baselib.delay 100, ->
      expect(testString).to.equal('0123456')
      done()

  it 'Execution Order is Correct for _setImmediateShim', (done)->

    testString = ''

    fn0 = -> testString += '0'
    fn2 = ->
      testString += '2'
      fn3()
    fn1 = -> testString += '1'
    fn3 = -> testString += '3'
    fn4 = ->
      testString += '4'
      baselib._setImmediateShim fn6
    fn5 = -> testString += '5'
    fn6 = -> testString += '6'

    baselib._setImmediateShim fn1
    baselib._setImmediateShim fn2
    baselib._setImmediateShim fn4
    baselib._setImmediateShim fn5
    fn0()

    baselib.delay 100, ->
      expect(testString).to.equal('0123456')
      done()
