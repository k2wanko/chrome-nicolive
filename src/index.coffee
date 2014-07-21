
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
        console.log 'data', data
