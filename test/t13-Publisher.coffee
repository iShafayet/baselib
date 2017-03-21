
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ Publisher } = baselib

describe 'Publisher', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('Publisher')
    .which.is.a('function')

  it 'Publisher#publishInSeries', (done)->

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
      expect(testString).to.equal('Aa1Ba1')
      done()

    baselib.delay 50, ->
      pub.publishInSeries 'a', 1

  it 'Publisher#publishInSeries with Zero Listeners', (done)->

    testString = ''

    pub = new Publisher

    pub.finally ->
      expect(testString).to.equal('')
      done()

    baselib.delay 50, ->
      pub.publishInSeries 'a', 1

  it 'Publisher#publishInParallel', (done)->

    testInteger = 0
    testString = ''

    pub = new Publisher

    pub.subscribe (finish, arg1, arg2)->
      testString += arg1 + arg2
      testInteger += 1
      finish()

    pub.subscribe (finish, arg1, arg2)->
      testString += arg1 + arg2
      testInteger += 2
      finish()

    pub.subscribe (finish, arg1, arg2)->
      testString += arg1 + arg2
      testInteger += 4
      finish()

    pub.finally ->
      expect(testString).to.equal('a1a1a1')
      expect(testInteger).to.equal(7)
      done()

    baselib.delay 50, ->
      pub.publishInParallel 'a', 1

  it 'Publisher#publishInParallel with Zero Listeners', (done)->

    testInteger = 0
    testString = ''

    pub = new Publisher

    pub.finally ->
      expect(testString).to.equal('')
      expect(testInteger).to.equal(0)
      done()

    baselib.delay 50, ->
      pub.publishInParallel 'a', 1


