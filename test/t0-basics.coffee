
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

describe 'baselib', ->

  it 'Existence', ->

    expect(baselib).to.be.an('object')  
