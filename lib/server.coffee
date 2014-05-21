File = require './api/File.coffee'

module.exports =
class Server
  constructor: (args) ->
    @host = atom.config.get('collab.host') or 'localhost'
    @port = atom.config.get('collab.port') or 8922
    return

  start: ->
    @io = require('socket.io').listen(@port)

    @io.sockets.on 'connection', (socket) ->
      socket.emit 'server~meta',
        "username": "Drew-server"

      socket.on 'client~meta', (data) ->
        @client = data
        manifest =
          "editors": {}

        atom.workspace.eachEditor (editor) ->
          manifest.editors[editor.id] =
            "uri": editor.getUri()
            "file": new File(editor.getText()).blobs
            "settings":
              "softTabs": editor.softTabs

          socket.emit 'server~manifest', manifest
          return
        return

      socket.on 'client~update', (data) ->
        editor = atom.workspace.getActiveEditor()
        editor.getBuffer().setTextInRange data.oldRange, data.newText
        return

      lastChange = null
      atom.subscribe atom.workspace.getActiveEditor().getBuffer(),
        'changed',
        (data) ->
          if lastChange is null
            lastChange = data
          else if lastChange isnt data
            socket.emit 'server~update', data
            lastChange = data
          return

      return
    return

  stop: -> #TODO: Reason
    @io.server.close()
    return

  #atom fields
  editors: []
  #The editors the server has opens these will
  # need to be listened to for changes
  treeView: null # The file treeview

  lastChange: null

  #Socket fields
  io: null
  host: null
  port: null
  client: null
