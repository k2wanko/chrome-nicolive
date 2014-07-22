###
#
# # chrome-xmlsocket.coffee
# Author: k2wanko k2.wanko[at]gmail.com
#
###

do =>
  # check package app.
  return console.error "Not package app." unless chrome?.app?

  # util
  ab2str = window.ab2str = (ab)->
    String.fromCharCode.apply String, new Uint16Array ab

  str2ab = window.str2ab = (str)->
    #str = unescape encodeURIComponent str
    buf = new ArrayBuffer str.length * 2
    bufView = new Uint16Array buf
    for char, i in str
      #console.log i, char
      bufView[i] = str.charCodeAt i
    return buf
    
  ###
  #
  # class: XMLsocket
  # 
  ###
  class XMLSocket
    id: null
    onready: null
    
    constructor: (@host, @port)->
      self = @
      chrome.sockets.tcp.create (info)->
        self.id = info.socketId
        console.log 'id', self.id, 'host', self.host, 'port', Number(self.port) if DEBUG
        setTimeout ->
          chrome.sockets.tcp.connect self.id, self.host, Number(self.port), (result)->
            console.log 'result', result if DEBUG
            chrome.sockets.tcp.onReceiveError.addListener (info)->
              console.log 'onReceiveError', arguments if DEBUG
              return unless info.socketId is self.id
              
            chrome.sockets.tcp.onReceive.addListener (info)->
              console.log 'onReceive', arguments if DEBUG
              return unless info.socketId is self.id
            self.onready.call self if self.onready
        , 500
          
    send: (data, callback)->
      console.log "id: #{@id}, data #{data}" if DEBUG
      chrome.sockets.tcp.send @id, str2ab data, (info)->
        console.log "send: ", info if DEBUG
           
    close: (callback)->
      chrome.sockets.tcp.close @id, callback.bind @
          
          
        
    
    
  window.XMLSocket = XMLSocket
