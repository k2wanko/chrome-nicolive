
do ($=jQuery)->
  appId = chrome.runtime.id

  sendMessage = window.sendMessage = (msg = {}, callback = (->))->
    chrome.runtime.sendMessage appId, msg, (res)->
      console.log "res", res
