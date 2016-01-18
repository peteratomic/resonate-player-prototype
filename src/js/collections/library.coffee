$ = require 'jquery'
_ = require 'underscore'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
Lame = require 'lame'
Speaker = require 'speaker'
Backbone = require 'backbone'
id3 = require 'id3js'

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

    fs.exists Settings.libraryPath, (exists)->

      if exists

        fs.readdir Settings.libraryPath, (err,files)->

          if err then console.log err

          _.each files, (file)->

            if file != '.DS_Store'

              song = new Song
                fileName: file

              id3 Settings.libraryPath+'/'+file, (error,tags)->
                console.dir tags
                song.set
                  title: tags.title
                  artist: tags.artist
                  album: tags.album

              tmpCollection.push song


          # Reset collection in bulk with collected songs
          self.reset tmpCollection,
            reset: true

      else

        # Directory doesn't exist
        # Create it
        mkdirp Settings.libraryPath, (error)->
          if error then console.log error


  addFile: (filePath)->

    fileName = path.basename(filePath, path.extname(filePath))+path.extname(filePath)
    fileDestination = Settings.libraryPath+'/'+fileName

    readFile = fs.createReadStream filePath
    writeFile = fs.createWriteStream fileDestination

    console.log 'Copying '+filePath+' to '+fileDestination
    readFile.pipe writeFile

    @add new Song
      fileName: fileName


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

