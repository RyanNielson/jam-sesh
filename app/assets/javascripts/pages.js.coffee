# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $ ->
#   inst = Math.floor((Math.random() * 4) + 1)
#   $('.note').data('instrument', inst)
#   $('.container').addClass('instrument-' + inst)

#   $('.note').on "click", ->
#       signal = [$(this).data('note'), $(this).data('instrument')]
#       alert(signal)

@playSound = (context, buffer) ->
  source = context.createBufferSource()
  source.buffer = buffer
  source.connect context.destination
  source.start 0

class @BufferLoader
  constructor: (context, urlListObj, callback) ->
    @context = context
    @urlListObj = urlListObj
    @onload = callback
    @bufferList = []
    @loadCount = 0

  load: ->
    for k, v of @urlListObj
      @loadBuffer(v, k)

  loadBuffer: (url, index) ->
    request = new XMLHttpRequest()
    request.open "GET", url, true
    request.responseType = "arraybuffer"
    loader = @

    request.onload = ->
      loader.context.decodeAudioData(
        request.response,
        (buffer) -> (
          if !buffer
            alert "error decoding file data: #{url}"
            return

          loader.bufferList[index] = buffer
          if ++loader.loadCount == _.size(loader.urlListObj)
            loader.onload loader.bufferList
        ),
        (error) -> 
          console.error "decodeAudioData error", error
      )

    request.onerror = ->
      alert "BufferLoader: XHR error"

    request.send()