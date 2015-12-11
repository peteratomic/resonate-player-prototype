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

    theSpeaker = null

    theStream = fs.createReadStream Settings.libraryPath+'/'+filename
    theStream.pipe(new Lame.Decoder())
      .on 'format', (format)->
        theSpeaker = new Speaker(format)
        @pipe theSpeaker

    theStream

