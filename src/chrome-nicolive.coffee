###
#
# # chrome-nicolive.coffee
# Author: k2wanko k2.wanko[at]gmail.com
# 
###

#= require lib/request.coffee

do =>
  
  nicolive = window.nicolive =
    host: 'live.nicovideo.jp'

  nicolive.requestLogin = (email, password, callback)->
    url = "https://secure.nicovideo.jp/secure/login?site=niconico"
    params =
      mail_tel: email
      password: password
      next_url: '/my/top'

    request.post url, params, (e, body, xhr)->
      return callback e if e
      return callback null, !(xhr.responseText.match /loginBox/)
  
  nicolive.getplayerstatus = (id, callback)->
    url = "http://watch.live.nicovideo.jp/api/getplayerstatus"
    request.get url, {v: id}, callback
