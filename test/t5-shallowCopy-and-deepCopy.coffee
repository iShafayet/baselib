
{ expect, assert } = require('chai')

baselib = require './../index.coffee'

{ shallowCopy, deepCopy } = baselib

describe 'shallowCopy', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('shallowCopy')
    .which.is.a('function')

  it 'General Use Case', (done)->

    testObject = {
      a: 3
      b:
        ba: 4
        bb: 5
      c: [
        1
        2
        {
          r: 3
          x: 4
        }
      ]
      d: new Date
    }

    copiedObject = shallowCopy testObject

    expect(testObject).to.deep.equal(copiedObject)

    expect(testObject.b).to.equal(copiedObject.b)

    done()


describe 'deepCopy', ->

  it 'Existence', ->

    expect(baselib)
    .to.have.property('deepCopy')
    .which.is.a('function')

  it 'General Use Case', (done)->

    testObject = {
      a: 3
      b:
        ba: 4
        bb: 5
      c: [
        1
        2
        {
          r: 3
          x: 4
        }
      ]
      d: new Date
    }

    copiedObject = deepCopy testObject

    expect(testObject).to.deep.equal(copiedObject)

    expect(testObject.b).to.not.equal(copiedObject.b)

    done()

