
do ($=jQuery)->
  appId = chrome.runtime.id

  sendMessage = window.sendMessage = (msg = {})->
    chrome.runtime.sendMessage appId, msg, {includeTlsChannelId: true}, (ret)->
      console.log ret
