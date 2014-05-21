module.exports =
class File

  blobs: []
  text: ''

  constructor: (args) ->
    if typeof args is 'string'
      blobs = args.split '\n'
      i = 0
      for blob in blobs
        @blobs[i] = blob
        i++
      console.log 'string'
    else
      @blobs = args

    return

  blobsToString: ->
    for blob in @blobs
      @text += blob
      @text += '\n'

    return @text
