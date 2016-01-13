$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'

module.exports = class MainView extends Backbone.View

  el: $('body')
  template: _.template '<div id="player" class="row">
      <div class="col-sm-4">
        <h2>Res(&nbsp;)nate</h2>
        <a class="stop">Stop</a>
        |
        <a class="resume">Resume</a>
      </div>
      <div class="col-sm-8">
        <h2>Playlist</h2>
        <ul id="playlist">
          <%
          if(songs && songs.length){
            _.each(songs,function(song){
              %><li><%= song.fileName %><a href="#" class="play" data-filename="<%= song.fileName %>">Play</a></li><%
            });
          } else {
            %><p>No songs in your library yet, drag and drop some into this window or copy them to [home]/Music/Resonate/</p><%
          }
          %>
        </ul>
      </div>
    </div>'

  library: null
  songPlaying: null
  currentSongName: null

  events:
    'click a.play': 'playSong'
    'click a.stop': 'stopPlaying'
    'click a.resume': 'resumePlaying'


  initialize: ->

    self = @

    _.bindAll this, 'render'
    @render()

    console.log @el

    @el.ondragover = ()-> return false
    @el.ondragleave = @el.ondragend =  ()-> return false
    @el.ondrop = (e)->

      e.preventDefault()
      file = e.dataTransfer.files[0]
      console.log 'File you dragged here is', file.path

      self.library?.addFile file.path

      false


  playSong: (event)->

    @stopPlaying()
    @songPlaying = @library?.play $(event.currentTarget).data('filename')
    @currentSongName = $(event.currentTarget).data('filename')


  stopPlaying: ->

    console.dir 'Stopping '+@currentSongName
    @library?.stop()


  resumePlaying: ->

    console.log 'Resume playing '+@currentSongName
    @library?.resume()


  setLibrary: (library)->

    @library = library
    library.on 'reset', @render
    library.on 'update', @render


  render: ->

    #console.log 'rendering'
    #console.dir @library?.toJSON()

    $(@el).html @template
      songs: @library?.toJSON()

