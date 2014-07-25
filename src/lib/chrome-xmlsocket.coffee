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
  NODE_TYPE = ELEMENT_NODE: 1, TEXT_NODE: 3, CDATA_SECTION_NODE: 4, COMMENT_NODE: 8, DOM: 9
  parse_xml = (dom)->
    #console.log "x", dom
    res = []
    if typeof dom is 'string'
      str = dom
      try
        parser = new DOMParser
        doc = parser.parseFromString str, "application/xml"
      catch e
        console.error e
      res.push
        doc: doc
        str: str
    else
      console.log dom
    #console.log res
    return res
    
  ###
  #
  # class: XMLsocket
  # 
  ###
  class XMLSocket
    id: null
    onready: null
    onreceive: null
    
    constructor: (@host, @port)->
      self = @
      chrome.sockets.tcp.create (info)->
        self.id = info.socketId
        console.log 'id', self.id, 'host', self.host, 'port', Number(self.port) if DEBUG
        setTimeout ->
          chrome.sockets.tcp.connect self.id, self.host, Number(self.port), (result)->
            console.log 'result', result if DEBUG
            
            console.error 'result', result unless result is 0

            chrome.sockets.tcp.onReceiveError.addListener (info)->
              #console.log 'onReceiveError', arguments if DEBUG
              return unless info.socketId is self.id
              console.log ab2str(info.data)
            xml_buffer = ""
            chrome.sockets.tcp.onReceive.addListener (info)->
              #console.log 'onReceive', window.data = arguments if DEBUG
              return unless info.socketId is self.id
              
              xml_buffer += ab2str(info.data)
              #tmp = xml_buffer.match(/(.*)(\/>|<\/[a-z]+>)/g)[0]
              xml_buffer = xml_buffer.substr(tmp.length)
              
              if self.onreceive?
                self.onreceive.call self, parse_xml(tmp)
              return
              
            self.onready.call self if self.onready
        , 1000
          
    send: (data, callback)->
      console.log "id: #{@id}, data #{data}" if DEBUG
      self = @
      chrome.sockets.tcp.send @id, str2ab(data), (info)->
        console.log "send: ", info if DEBUG
        callback.call self if callback
           
    close: (callback)->
      callback = ( -> ) unless callback
      chrome.sockets.tcp.close @id, callback.bind(@)
          
          
        
    
    
  window.XMLSocket = XMLSocket
