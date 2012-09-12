should = require 'should'
assert = require 'assert'
appygram = require __dirname + '/../lib/appygram'

describe 'Appygram', ->
  it 'should default to an undefined api_key', (done)->
    assert.equal appygram.api_key, undefined
    done()
  it 'should have the correct version number', (done)->
    assert.equal appygram.version, JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version
    done()
