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

  nicolive.getCruiseId = (callback)->
    url = "http://live.nicovideo.jp/cruise"
    request.get url, (err, data)->
      return console.error err if err
      id = (  data.match /lv([0-9]+)/g )[0]
      return new Error "Not found." unless id
      callback null, id
  
  nicolive.getplayerstatus = (id, callback)->
    url = "http://watch.live.nicovideo.jp/api/getplayerstatus"
    request.get url, {v: id}, (err, data, xhr)->
      return callback err if err

      find = (doc, name, first)->
        tags = doc.getElementsByTagName name
        return null unless tags.length > 0
        tags = for tag in tags
          tag.find = find.bind tag, tag
          tag
        return tags[0] if first
        return tags

      xhr.find = find.bind xhr.responseXML, xhr.responseXML

      if error = xhr.find 'error', true
        return console.error new Error (error.find 'code', true).innerHTML
        
      res =
        id: id
        
      set = (s, name)-> @[name] = if s.find(name, true) then s.find(name, true).innerHTML else null
      if stream = xhr.find 'stream', true
        stream_set = set.bind res, stream
        stream_set name for name in [
          'title', 'description', 'default_community'
          'owner_id', 'owner_name', 'is_owner', 'is_reserved'
          'picture_url', 'thumb_url'
          'watch_count', 'comment_count', 'danjo_comment_mode', 'relay_comment'
          'base_time', 'open_time', 'start_time', 'end_time'
          'is_cruise_stream', 'is_rerun_stream', 'is_archiveplayserver'
          'bourbon_url', 'full_video', 'after_video', 'twitter_tag'
          'infinity_mode', 'archive'
        ]
      if ms = xhr.find 'ms', true
        ms_res = {}
        ms_set = set.bind ms_res, ms
        ms_set name for name in ['addr', 'port', 'thread']
        res.ms =  ms_res
      if rtmp = xhr.find 'rtmp', true
        rtmp_res = {}
        rtmp_set = set.bind rtmp_res, rtmp
        rtmp_set name for name in ['url', 'ticket']
        rtmp_res.rtmpt_port = rtmp.getAttribute "rtmpt_port"
        rtmp_res.is_fms = rtmp.getAttribute "is_fms"
        res.rtmp = rtmp_res
      callback null, res
