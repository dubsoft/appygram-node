Singleton = require 'singleton'
request = require 'request'

class Appygram extends Singleton
  constructor:()->
    @api_key = undefined
    @endpoint = 'https://appygram.appspot.com/traces'
    @version = JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version

  setApiKey:(api_key)->
    @api_key = api_key

  errorHandler:(err, res, req, next)->
    appy = Appygram.get()
    if appy.api_key is undefined
      console.error 'Please define Appygram\'s API_KEY with appygram.api_key = \'your_api_key\' or appygram.setApiKey(\'your_api_key\')
        \ If you need an API key please visit http://www.appygram.com/dashboard and request one for your project.'
    else
      error = new Error err
      params =
        api_key:appy.api_key
        name:"Exception"
        topic:"Exception"
        message: error.toString()
        trace:
          class:error.message
          message:error.message
          backtrace:error.stack.split '\n'
        platform: "appygram-node#{appy.version}"
        software: "node application"

      options =
        uri:appy.endpoint
        method:'POST'
        body: JSON.stringify params
        json:true
        headers:
          "User-Agent":"appygram-node/#{appy.version}"
          "Accept":"application/json"
          "Content-Type":"application/json"
      request options, (error, response, body)->
        console.log 'Processed appygram'
        if appy.debug
          next err
      next err if next? and not appy.debug

module.exports = Appygram.get()
