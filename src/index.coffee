
do ($=jQuery)->
  appId = chrome.runtime.id

  $ ->

    if DEBUG
      $("#live_id").val "lv186806447"

    $("#live_go").click ->
      console.log $("#live_id").val()
