
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ AsyncCondition } = baselib

describe 'AsyncCondition', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('AsyncCondition')
    .which.is.a('function')

  it 'General Use Case (truthy, eval as expression)', (done)->

    testFlag = null

    c1 = new AsyncCondition
    c1.eval true is true
    c1.then (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = true
      cbfn()
    c1.else (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = false
      cbfn()
    c1.finally ->
      expect(testFlag).to.equal(true)
      done()

  it 'General Use Case (falsy, eval as expression)', (done)->

    testFlag = null

    c1 = new AsyncCondition
    c1.eval true is false
    c1.then (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = true
      cbfn()
    c1.else (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = false
      cbfn()
    c1.finally ->
      expect(testFlag).to.equal(false)
      done()

  it 'Not executed if AsyncCondition#eval is never called', (done)->

    testFlag = null

    c1 = new AsyncCondition
    # c1.eval true is true
    c1.then (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = true
      cbfn()
    c1.else (cbfn)->
      expect(cbfn).to.be.a('function')
      testFlag = false
      cbfn()
    c1.finally ->
      expect(testFlag).to.equal('SHOULDNOTEQUAL')
      done()

    baselib.delay 200, done