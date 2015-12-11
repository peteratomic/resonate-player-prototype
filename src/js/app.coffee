#
# Resonate player prototype
# Author: TOM WOR <mail@tomwor.com>
#

$ = window.jQuery = require 'jquery'
_ = window.Underscore = require 'underscore'

window.ResonateApp = {}
ResonateServer = require './js/server.js'
ResonatePlayer = require './js/player.js'


$ ->

  player = new ResonatePlayer
  player.init()

  # Chaosradio - Internet of things
  #ResonatePlayer.playMagnetLink 'magnet:?xt=urn:btih:13755337e1894dc348139cf0422a904267d744f6&dn=cr218-inernetofthings.mp3'
  #ResonatePlayer.playMagnetLink 'magnet:?xt=urn:btih:0a6f410ccfa594579afdf4b4daa887c6a02c5acb&dn=cr215-daschaoscommunicationcamp.mp3'


