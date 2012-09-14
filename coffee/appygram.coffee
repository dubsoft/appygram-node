Singleton = require 'singleton'
request = require 'request'

class Appygram extends Singleton
  constructor:()->
    @api_key = undefined
    @format = 'json'
    @endpoint = 'http://api.appygram.com'
    @version = JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version

  setApiKey:(api_key)->
    @api_key = api_key

  errorHandler:(err, res, req, next)->
    appy = Appygram.get()
    if appy.api_key is undefined
      console.error 'Please define Appygram\'s API_KEY with appygram.api_key = \'your_api_key\' or appygram.setApiKey(\'your_api_key\')
        \ If you need an API key please visit http://www.appygram.com/dashboard and request one for your project.'
    else
      params =
        api_key:appy.api_key
        name:"Exception"
        topic:"Exception"
        message: appy.formatMessage err
        platform: "appygram-node#{appy.version}"
        software: "node application"

      options =
        uri:appy.endpoint + '/appygrams'
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

  formatMessage:(error)=>
    switch @format
      when 'json'
        return JSON.stringify error
      when 'text'
        return String error


module.exports = Appygram.get()
