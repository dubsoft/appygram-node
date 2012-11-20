should = require 'should'
assert = require 'assert'
appygram = require __dirname + '/../lib/appygram'
appygram.debug = true
message = new Error "Error: ERROR_TESTING"

describe 'Appygram', ->
  it 'should default to an undefined api_key', ()->
    assert.equal appygram.api_key, undefined
  it 'should use the traces endpoint', ()->
    assert.equal appygram.endpoint, 'https://appygram.appspot.com/traces'
  it 'should have the correct version number', ()->
    assert.equal appygram.version, JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version
  it 'should set the api_key', (done)->
    api_key = 'cb96a697cec9bb9c1a57db549bb3d1b00129a7af'
    appygram.setApiKey api_key
    assert.equal appygram.api_key, api_key
    done()
  it 'should send an exception and pass the error', (done)->
    appygram.errorHandler message, {}, {}, (error)->
      done()
  it 'should have the option to set user info on error', ()->
    assert.equal appygram.user_location, 'user'
    appygram.user_location = 'current_user'
    assert.equal appygram.user_location, 'current_user'
  it 'shouldn\'t look for a user by default', ()->
    assert.equal appygram.include_user, false
    appygram.include_user = true
    assert.equal appygram.include_user, true
  it 'should allow user to set app name', ()->
    assert.equal appygram.app_name, 'node application'
    appygram.app_name = 'mocha test suite'
    assert.equal appygram.app_name, 'mocha test suite'
  it 'should let a user reset to default', ()->
    appygram.reset_to_default()
    assert.equal appygram.app_name, 'node application'
    assert.equal appygram.api_key, undefined

