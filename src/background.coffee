
appId = chrome.runtime.id

#= require_tree lib/

chrome.runtime.onMessage.addListener (msg, sender, res)->
  return res error: "Unknown" unless sender.id is appId

  if msg?.cmd?
    switch msg.cmd
      when 'login'
        commands.login msg, res
      else
        res {error: "Not found commad. " + msg.cmd}
  else
    res
      error: "defined 'cmd'"

chrome.app.runtime.onLaunched.addListener ->
  width = 800
  height = 600

  chrome.app.window.create 'index.html',
    id: 'main'
    bounds:
      width: width
      height: height
      left: Math.round (screen.availWidth - width) / 2
      top: Math.round (screen.availHeight - height)/ 2
    
  , (app_window)->
    
