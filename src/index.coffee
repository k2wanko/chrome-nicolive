
do ($=jQuery)->
  appId = chrome.runtime.id

  $ ->

    
    
    if DEBUG
      nicolive.getCruiseId (err, id)->
        console.error err if err
        $("#live_id").val id
    xs = null
    $("#live_go").click ->
      live_id = $("#live_id").val()
      return unless live_id?.length > 0

      if xs?
        live_id.text 'go'
        xs.close()
        xs = null
        return 
      
      nicolive.getplayerstatus live_id, (err, data)->
        return console.error err if err
        console.log 'data', data if DEBUG
        ms = data.ms
        xs = window.xs = new XMLSocket ms.addr, ms.port
        xs.onreceive = (data)->
          $('#comments').append data
        xs.onready = ->
          console.log xs if DEBUG
          xs.send '<thread thread="' + ms.thread + '" version="20061206" res_from="-50" scores="1"/>', (info)->
            live_id.text 'close'
            
        
        
        new Vue
          el: "#contents"
          data: data
