$ = require 'jquery'
_ = require 'underscore'
fs = require 'fs'
Lame = require 'lame'
Speaker = require 'speaker'
Backbone = require 'backbone'
Song = require '../models/song'
Settings = require '../settings'

module.exports = class Library extends Backbone.Collection

  model: Song

  stream: null
  speaker: null
  decoder: null


  initialize: ->

    self = @

    # temporary array of songs to update collection in bulk
    tmpCollection = []

    #console.log 'from library: '+Settings.libraryPath

    fs.readdir Settings.libraryPath, (err,files)->

      if err then console.log err

      _.each files, (file)->

        tmpCollection.push new Song
          fileName: file

      # Reset collection in bulk with collected songs
      self.reset tmpCollection,
        reset: true


  play: (filename)->

    console.log 'playing '+filename

    @speaker = new Speaker()
    @decoder = new Lame.Decoder()

    @stream = fs.createReadStream Settings.libraryPath+'/'+filename
    @decoder.pipe @speaker
    @stream.pipe @decoder

    @speaker


  stop: ->

    @decoder?.unpipe()


  resume: ->

    @decoder?.pipe @speaker

