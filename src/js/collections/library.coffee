$ = window.jQuery = require 'jquery'
_ = window.Underscore = require 'underscore'
fs = require 'fs'
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



