Singleton = require 'singleton'

class Appygram extends Singleton
  constructor:()->
    @api_key = undefined

  errorHandler:(err, req, res, next)->
    if @api_key is undefined
      console.err 'Please define Appygram\'s API_KEY with appygram.api_key = \'your_api_key\' or appygram.setApiKey(\'your_api_key\')
        \ If you need an API key please visit http://www.appygram.com/dashboard and request one for your project.'



module.exports = Appygram.get()

