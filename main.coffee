StackMob = require("./stackmob-js-0.2.1").StackMob
# _ = require("underscore")
_ = require('lodash')
jsOAuth = undefined
_makeOAuthAjaxCall = (model, params, method) ->
  success = params["success"]
  defaultSuccess = (response, options) ->
    params["stackmob_on" + method]()  if _.isFunction(params["stackmob_on" + method])
    if response.text
      result = JSON.parse(response.text)
      console.log response
      if params["stackmob_count"] is true
        _.extend response, 
          getAllResponseHeaders: ->
          getResponseHeader: (name)->
            response.responseHeaders[name.toLowerCase()]
        success response
      else if(model.clear)
        model.clear()
        return false unless model.set(result)
        success model
      else
        success result
    else
      success()
  params["success"] = defaultSuccess
  error = params["error"]
  defaultError = (response) ->
    result = (if response.text then JSON.parse(response.text) else response)
    ((m, d) ->
      error m, d
    ).call StackMob, model, result
  params["error"] = defaultError
  hash = {}
  hash["url"] = params["url"]
  hash["headers"] = params["headers"]
  hash["success"] = params["success"]
  hash["failure"] = params["error"]
  hash["method"] = params["type"]
  hash["data"] = params["data"]
  hash["headers"]["Content-Type"] = "application/json"  if _.include(["PUT", "POST"], hash["method"])
  jsOAuth?.request hash

# request = require("request")

_.extend StackMob,
  initStart: (options)->
    # options.ajax = (model, params, method) ->
    #   console.log params
    #   success = params["success"]
    #   error = params["error"]
    #   hash = {}
    #   hash["url"] = params["url"]
    #   hash["headers"] = params["headers"]
    #   hash["headers"]["Content-Type"] = "application/json"  if hash["method"] is "PUT" or hash["method"] is "POST"
    #   hash["method"] = params["type"]
    #   hash["oauth"] = 
    #     consumer_key: options.consumerKey
    #     consumer_secret: options.consumerSecret
    #   hash["qs"] = params["data"]
    #   request hash, (error, response, body) ->
    #     console.log "xxxxxxBODYxxxxxx"
    #     console.log body
    #     console.log body  if not error and response.statusCode is 200
    #     if error
    #       result = (if body then JSON.parse(body) else response)
    #       ((m, d) ->
    #         error d
    #       ).call StackMob, model, result
    #     else
    #       params["stackmob_on" + method]()  if _.isFunction(params["stackmob_on" + method])
    #       if body
    #         result = JSON.parse(body)
    #         model.clear()
    #         if params["stackmob_count"] is true
    #           success response
    #         else return false  unless model.set(result)
    #         success model
    #       else
    #         success()
    options.ajax = _makeOAuthAjaxCall
    jsOAuth = require("./jsOAuth-1.3.3").OAuth(options);

module.exports = StackMob