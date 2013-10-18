@playSound = (context, buffer) ->

  #instances
  instances = [{time: 0, gain: 1}, {time: 0.3, gain: 0.5}, {time: 0.6, gain: 0.25}, {time: 0.9, gain: 0.125}]

  for i in [0...instances.length]
    #sample
    instances[i].sample = context.createBufferSource()
    instances[i].sample.buffer = buffer

    #sample gain
    instances[i].gainNode = context.createGainNode()
    instances[i].gainNode.gain.value = 1

    #delay
    instances[i].delayNode = context.createDelayNode()
    instances[i].delayNode.delayTime.value = instances[i].time

    #delay gain
    instances[i].delayGainNode = context.createGainNode()
    instances[i].delayGainNode.gain.value = instances[i].gain

    #connections
    instances[i].sample.connect instances[i].gainNode
    instances[i].gainNode.connect instances[i].delayNode
    instances[i].delayNode.connect instances[i].delayGainNode
    instances[i].delayGainNode.connect context.destination

    #play
    instances[i].sample.start 0
    console.log i

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