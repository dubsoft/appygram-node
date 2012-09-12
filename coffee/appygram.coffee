Singleton = require 'singleton'
request = require 'request'

class Appygram extends Singleton
  constructor:()->
    @api_key = undefined
    @format = 'json'
    @endpoint = 'http://192.168.1.71:3000'
    @version = JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version

  setApiKey:(@api_key)->

  errorHandler:(err, req, res, next)->
    if @api_key is undefined
      console.err 'Please define Appygram\'s API_KEY with appygram.api_key = \'your_api_key\' or appygram.setApiKey(\'your_api_key\')
        \ If you need an API key please visit http://www.appygram.com/dashboard and request one for your project.'
    else
      params =
        api_key:@api_key
        name:"Exception"
        topic:"Exception"
        message: @formatMessage err
        platform: "appygram-node#{@version}"
        software: "node application"

      options =
        uri:@endpoint + '/appygrams'
        method:'POST'
        body: JSON.stringify params
        json:true
        headers:
          "User-Agent":"appygram-node/#{@version}"
          "Accept":"application/json"
          "Content-Type":"application/json"
      request options, (error, response, body)->
        console.log error
        console.log body
        process.nextTick ->
          next err


  formatMessage:(error)->
    switch @format
      when 'json'
        return JSON.stringify error
      when 'text'
        return String error


module.exports = Appygram.get()

