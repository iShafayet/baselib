
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ AsyncCondition, asyncIf } = baselib

describe 'asyncIf', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('asyncIf')
    .which.is.a('function')

  it 'asyncIf maps to AsyncCondition', ->

    con = asyncIf 'TEST'
    expect(con).to.be.an.instanceOf(AsyncCondition)
    expect(con.expression).to.equal('TEST')


