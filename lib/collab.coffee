Client = require './client'
Server = require './server'

module.exports =

  client: null
  server: null

  activate: (state) ->
    atom.workspaceView.command 'collab:connect', => @connect()
    atom.workspaceView.command 'collab:disconnect', => @client.disconnect(0)
    atom.workspaceView.command 'collab:server', => @start()
    atom.workspaceView.command 'collab:server-stop', => @server.stop()
    return

  connect: ->
    @client = new Client {}
    @client.connect()
    return

  start: ->
    @server = new Server {}
    @server.start()
    return

  deactivate: ->
    return

  serialize: ->
    return
