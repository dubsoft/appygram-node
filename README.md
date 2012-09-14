Appygram-node
=============

An Appygram connector


##Build Status

[![Build
Status](https://secure.travis-ci.org/wlaurance/appygram-node.png)](http://travis-ci.org/wlaurance/appygram-node)

##Usage

### Express
```
  var appygram = require('appygram');
  ...
  appygram.setApiKey('your_api_key');
  app.use(appygram.errorHandler);
```
