should = require 'should'
assert = require 'assert'
appygram = require __dirname + '/../lib/appygram'
appygram.debug = true
message = new Error "Error: ERROR_TESTING"

describe 'Appygram', ->
  it 'should default to an undefined api_key', (done)->
    assert.equal appygram.api_key, undefined
    done()
  it 'should use the traces endpoint', (done)->
    assert.equal appygram.endpoint, 'https://appygram.appspot.com/traces'
    done()
  it 'should have the correct version number', (done)->
    assert.equal appygram.version, JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version
    done()
  it 'should set the api_key', (done)->
    api_key = 'cb96a697cec9bb9c1a57db549bb3d1b00129a7af'
    appygram.setApiKey api_key
    assert.equal appygram.api_key, api_key
    done()
  it 'should send an exception and pass the error', (done)->
    appygram.errorHandler message, {}, {}, (error)->
      done()
