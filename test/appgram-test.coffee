should = require 'should'
assert = require 'assert'
appygram = require __dirname + '/../lib/appygram'
appygram.debug = true
message = "Error: Cannot find module 'blaha'        at Function._resolveFilename (module.js:337:11)            at Function._load (module.js:279:25)                at Module.require (module.js:359:17)                    at require (module.js:375:17)                        at repl:1:2                            at REPLServer.eval (repl.js:80:21)                                at Interface.<anonymous> (repl.js:182:12)                                    at Interface.emit (events.js:67:17)                                        at Interface._onLine (readline.js:162:10)                                            at Interface._line (readline.js:426:8)"

describe 'Appygram', ->
  it 'should default to an undefined api_key', (done)->
    assert.equal appygram.api_key, undefined
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
    appygram.format = 'text'
    appygram.errorHandler message, {}, {}, (error)->
      assert.equal error, message
      done()
  it 'should have a duplicate limit', ()->
    assert.equal appygram.duplicateLimit, 0
    appygram.setDuplicateLimit 2
    assert.equal appygram.duplicateLimit, 2

