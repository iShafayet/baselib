
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ delay } = baselib

describe 'delay', ->

  it 'Existence', ->

    expect(baselib).to.have.property('delay')
    .which.is.a('function')

  it 'General Use Case', (done)->

    timeStamp = (new Date).getTime()
    delay 300, ->
      now = (new Date).getTime()
      expect(now - timeStamp).to.be.closeTo 300, 10
      done()