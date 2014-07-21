###
#
# # chrome-nicolive.coffee
# Author: k2wanko k2.wanko[at]gmail.com
# 
###


do =>
  
  #= require request.coffee
  #= chrome-xmlsocket.coffee
  
  nicolive = window.nicolive =
    host: 'live.nicovideo.jp'

  nicolive.requestLogin = (email, password, callback)->
    url = "https://secure.nicovideo.jp/secure/login?site=niconico"
    params =
      mail_tel: email
      password: password
  
    request.post url, params, (e, body)->
      console.log body
  
  nicolive.getplayerstatus = (id, callback)->
    url = "http://watch.live.nicovideo.jp/api/getplayerstatus"
    request.get url, {v: id}, callback
