
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ merge } = baselib

describe 'merge', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('merge')
    .which.is.a('function')

  it 'String', ->

    a = 'A'
    b = 'B'
    c = 'A'

    m = merge a, b

    expect(m).to.equal(c)

  it 'Boolean', ->

    a = false
    b = true
    c = false

    m = merge a, b

    expect(m).to.equal(c)

  it 'null', ->

    a = null
    b = null
    c = null

    m = merge a, b

    expect(m).to.equal(c)

  it 'null Left', ->

    a = 'A'
    b = null
    c = 'A'

    m = merge a, b

    expect(m).to.equal(c)

  it 'undefined Right', ->

    a = undefined
    b = 'B'
    c = 'B'

    m = merge a, b

    expect(m).to.equal(c)

  it 'Array + Array', ->

    a = [ 'A', 'B' ]
    b = [ '3', 2, undefined ]
    c = [ 'A', 'B', '3', 2, undefined ]

    m = merge a, b

    expect(m).to.not.equal(c)
    expect(m).to.deep.equal(c)

  it 'Array + String', ->

    a = [ 'A', 'B' ]
    b = 'AAA'
    c = [ 'A', 'B' ]

    m = merge a, b

    expect(m).to.deep.equal(c)

  it 'String + Array', ->

    a = 'AAA'
    b = [ 'A', 'B' ]
    c = 'AAA'

    m = merge a, b

    expect(m).to.deep.equal(c)

  it 'Object + Object', ->

    a = { a: 1, c: 3.1 }
    b = { b: 2, c: 3.2 }
    c = { a: 1, b: 2, c: 3.1 }

    m = merge a, b

    expect(m).to.not.equal(c)
    expect(m).to.deep.equal(c)

  it 'Object + String', ->

    a = { a: 1 }
    b = 'AAA'
    c = { a: 1 }

    m = merge a, b

    expect(m).to.deep.equal(c)

  it 'String + Object', ->

    a = 'AAA'
    b = { a: 1 }
    c = 'AAA'

    m = merge a, b

    expect(m).to.deep.equal(c)

  it 'deep Object + deep Object', ->

    a = { a: 1, c: { d: 4, e: 5 } }
    b = { b: 2, c: { d: 4, f: 6 } }
    c = { a: 1, b: 2, c: { d: 4, e: 5, f: 6 } }

    m = merge a, b

    expect(m).to.not.equal(c)
    expect(m).to.deep.equal(c)

