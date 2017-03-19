
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ once } = baselib

describe 'once', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('once')
    .which.is.a('function')

  it 'General Use Case', ->

    testInteger = 0

    fn = -> testInteger += 1

    oFn = once fn

    oFn()
    oFn()
    oFn()

    expect(testInteger).to.equal(1)

  it 'Ensure Correct Execution Context', ->

    class Test

      constructor: ->
        @repeatableCalled = 0
        @nonRepeatableCalled = 0

      repeatable: (testVar)->
        unless testVar is 'A'
          throw new Error "Something went wrong"
        @repeatableCalled += 1

      nonRepeatable: once (testVar)->
        unless testVar is 'A'
          throw new Error "Something went wrong"
        @nonRepeatableCalled += 1

    t1 = new Test

    t1.repeatable('A')
    t1.repeatable('A')
    t1.repeatable('A')

    t1.nonRepeatable('A')
    t1.nonRepeatable('A')
    t1.nonRepeatable('A')

    expect(t1.repeatableCalled).to.equal(3)
    expect(t1.nonRepeatableCalled).to.equal(1)
