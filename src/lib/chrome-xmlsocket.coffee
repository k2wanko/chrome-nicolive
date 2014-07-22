###
#
# # chrome-xmlsocket.coffee
# Author: k2wanko k2.wanko[at]gmail.com
#
###

do =>
  # util
  ab2str = window.ab2str = (ab)->
    decodeURIComponent escape String.fromCharCode.apply String, new Uint8Array ab

  str2ab = window.str2ab = (str)->
    str = unescape encodeURIComponent str
    buf = new ArrayBuffer str.length * 2
    bufView = new Uint8Array buf
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
            
            console.error 'result',result unless result is 0
            
            chrome.sockets.tcp.onReceiveError.addListener (info)->
              #console.log 'onReceiveError', arguments if DEBUG
              return unless info.socketId is self.id
              console.log ab2str(info.data)
              
            chrome.sockets.tcp.onReceive.addListener (info)->
              #console.log 'onReceive', window.data = arguments if DEBUG
              return unless info.socketId is self.id
              console.log ab2str(info.data)
            self.onready.call self if self.onready
        , 1000
          
    send: (data, callback)->
      console.log "id: #{@id}, data #{data}" if DEBUG
      chrome.sockets.tcp.send @id, str2ab(data), (info)->
        console.log "send: ", info if DEBUG
           
    close: (callback)->
      chrome.sockets.tcp.close @id, callback.bind @
          
          
        
    
    
  window.XMLSocket = XMLSocket
