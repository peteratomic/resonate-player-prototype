WebTorrent = require 'webtorrent'
PrettyBytes = require 'pretty-bytes'
Util = require 'util'
path = require 'path'
MainView = require './views/mainView.js'
Settings = require './settings'


class ResonatePlayer


  # Initialize player
  init: ->

    console.log 'Initializing resonate player'
    mainView = new MainView
    console.log 'library: '+Settings.libraryPath


  # Play a magnet link
  playMagnetLink: (magnetURI)->

    @client = new WebTorrent
    @downloadProgressInterval = null

    self = @

    self.client.add magnetURI, (torrent)->

      torrentFileName = path.basename(torrent.name, path.extname(torrent.name)) + '.torrent'
      console.log torrentFileName

      # Got torrent metadata!
      console.log('Client is downloading:', torrent.infoHash)

      updateSpeed = ->
        progress = (100 * torrent.downloaded / torrent.length).toFixed(1)
        Util.log(
          'Peers: ' + torrent.swarm.wires.length + ' ' +
          'Progress: ' + progress + '% ' +
          'Download speed: ' + PrettyBytes(self.client.downloadSpeed()) + '/s ' +
          'Upload speed: ' + PrettyBytes(self.client.uploadSpeed()) + '/s'
        )

      torrent.swarm.on 'download', updateSpeed
      torrent.swarm.on 'upload', updateSpeed
      updateSpeed()

      torrent.files.forEach (file)->

        console.log 'DOWNLOADED'
        console.log torrent.infoHash

        # Display the file by appending it to the DOM. Supports video, audio, images, and
        # more. Specify a container element (CSS selector or reference to DOM node).
        file.appendTo('body')


module.exports = new ResonatePlayer

