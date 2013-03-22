Singleton = require 'singleton'
request = require 'request'

class Appygram extends Singleton
  constructor:()->
    @defaults()

  defaults:()->
    @api_key = undefined
    @endpoint = 'https://arecibo.appygram.com/traces'
    @version = JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version
    @user_location = 'user'
    @include_user = false
    @app_name = "node application"

  setApiKey:(api_key)->
    @api_key = api_key

  reset_to_default:()->
    @defaults()

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
        trace: JSON.stringify
          class:error.message
          message:error.message
          backtrace: appy.parseBackTrace error.stack
        platform: "appygram-node#{appy.version}"
        software: appy.app_name
        app_json:
          user: JSON.stringify req[appy.user_location] if appy.include_user and req[appy.user_location]?

      options =
        uri:appy.endpoint
        method:'POST'
        body: JSON.stringify params
        json:true
        headers: appy.getHeaders()
      appy.sendAppygram options, ->
        if appy.debug
          next err
      next err if next? and not appy.debug

  parseBackTrace:(trace)->
    list = trace.split '\n'
    traces = []
    for trace in list
      traceList = []
      msgs = trace.split '('
      if msgs.length > 1
        traceList.push msgs[0]
        rest = msgs[1].split ':'
        traceList.push rest[0]
        traceList.push rest[1]
      if traceList.length > 0
        traces.push traceList
    return traces

  sendAppygram:(gram, callback)->
    request gram, (error, response, body)->
      console.log 'Processed appygram'
      callback()

  getHeaders:()->
    appy = Appygram.get()
    return {
      "User-Agent":"appygram-node/#{appy.version}"
      "Accept":"application/json"
      "Content-Type":"application/json"
    }

  sendFeedback:(feedback, callback)->
    appy = Appygram.get()
    feedback.api_key = appy.api_key
    feedback.name = "Feedback"
    feedback.topic = "Feedback"
    feedback.platform = "appygram-node#{appy.version}"
    feedback.software = appy.app_name
    appy.sendAppygram
      uri:appy.endpoint
      method:'POST'
      body: JSON.stringify feedback
      json: true
      headers:appy.getHeaders()
      , callback


module.exports = Appygram.get()
