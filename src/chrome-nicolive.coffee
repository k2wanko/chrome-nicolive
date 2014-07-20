###
#
# # chrome-nicolive.coffee
# Author: k2wanko k2.wanko[at]gmail.com
# 
###

# check name space
if nicolive
  console.error "Defined namespace."
  return

#= require_tree lib

## util ##
request =
  get: (url, params, callback)->
    [callback, params] = [params, callback] unless callback
    query = if params then request._encode(params) else null
    url = url + '?' + query if query
    console.log "GET ", params, query, url
      
    xhr = new XMLHttpRequest
    xhr.onreadystatechange = do -> request._onreadystatechange xhr, callback

    xhr.open 'GET', url
  
    xhr.send()

  post: (url, params, callback)->  
    [callback, params] = [params, callback] unless callback
    query = if params then request._encode(params) else null
      
    xhr = new XMLHttpRequest
    xhr.onreadystatechange = do -> request._onreadystatechange xhr, callback
    
    xhr.open 'POST', url
    xhr.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'
    xhr.send query

  _onreadystatechange: (xhr, callback)->
    ->
      COMPLETED = 4
      STATUS_OK = 200

      if xhr.readyState is COMPLETED and xhr.status is STATUS_OK
        callback.call {}, null, xhr.responseText, xhr
    
  _encode: (params)->
    encode = (str)=> encodeURIComponent(str).replace( /%20/g, '+' )
    ( encode(k) + '=' + encode(v) for k, v of params).join '&'

  
nicolive = window.nicolive =
  host: 'live.nicovideo.jp'

nicolive.requestLogin = (email, password)->
  url = "https://secure.nicovideo.jp/secure/login?site=niconico"
  params =
    mail_tel: email
    password: password

  request.post url, params, (e, body)->
    console.log body

nicolive.getplayerstatus = (id, callback)->
  url = "http://watch.live.nicovideo.jp/api/getplayerstatus"
  request.get url, {v: id}, callback
