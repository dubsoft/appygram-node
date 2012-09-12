Singleton = require 'singleton'
request = require 'request'

class Appygram extends Singleton
  constructor:()->
    @api_key = undefined
    @format = 'json'
    @endpoint = 'http://api.appygram.com'
    @version = JSON.parse((require 'fs').readFileSync __dirname + '/../package.json').version

  errorHandler:(err, req, res, next)->
    if @api_key is undefined
      console.err 'Please define Appygram\'s API_KEY with appygram.api_key = \'your_api_key\' or appygram.setApiKey(\'your_api_key\')
        \ If you need an API key please visit http://www.appygram.com/dashboard and request one for your project.'
    else
      request.post @endpoint + '/feedback_messages',
        api_key:@api_key
        "feedback_message[topic]":'Exception'
        "feedback_message[message]": @formatMessage err
        headers:
          Accept: "application/json"
          "User-agent":"appygram-node/#{@version}"
      , (error, response, body)->
        process.nextTick ->
          next err


  formatMessage:(error)->
    switch @format
      when 'json'
        return JSON.stringify error


module.exports = Appygram.get()

