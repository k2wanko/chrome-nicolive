
do ($=jQuery)->
  appId = chrome.runtime.id

  $ ->

    if DEBUG
      nicolive.getCruiseId (err, id)->
        console.error err if err
        $("#live_id").val id

    $("#live_go").click ->
      live_id = $("#live_id").val()
      return unless live_id?.length > 0
      nicolive.getplayerstatus live_id, (err, data)->
        return console.error err if err
        console.log 'data', data if DEBUG
        ms = data.ms
        xs = new XMLSocket ms.addr, ms.port
        xs.onready = ->
          #console.log xs
          xs.send '<thread thread="' + ms.thread + '" version="20061206" res_from="-50" scores="1"/>', (info)->
            
        
        
        new Vue
          el: "#contents"
          data: data
