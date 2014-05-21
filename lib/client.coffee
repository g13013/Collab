File = require './api/File'

module.exports =
class Client
  contructor: (@args) ->
    return

  connect: ->
    io = require 'socket.io-client'

    console.log "http://#{@host}:#{@port}"

    @socket = io.connect "http://#{@host}:#{@port}"
    socket = @socket

    @socket.on 'connect', ->
      console.log "connected"
      return

    @socket.on 'server~meta', (data) ->
      @server = data
      return

    @socket.emit 'client~meta',
      "username": "Drew-client"

    @socket.on 'server~manifest', (data) ->
      console.log 'server~manifest'
      file = new File data.editors[27].file
      editor = atom.workspace.getActiveEditor()
      editor.setText file.blobsToString()
      editor.setSoftTabs data.editors[27].settings.softTabs
      editor.buffer.uri = data.editors[27].uri
      return

    @socket.on 'server~update', (data) ->
      editor = atom.workspace.getActiveEditor()
      editor.getBuffer().setTextInRange data.oldRange, data.newText
      atom.subscribe atom.workspace.getActiveEditor().getBuffer(),
        'changed',
        (data) ->
          socket.emit 'client~update', data
          return
      return

    @socket.on 'close', -> #TODO:
      console.log 'disconnected'
      return

    return

  disconnect: ->
    @socket.disconnect
    console.log 'disconnected'
    return

  #editor fields
  editors: [] #Holds the editors that are being mirrored on the client

  #Socket fields
  socket: null
  host: 'localhost'
  port: 8922
  server: null
