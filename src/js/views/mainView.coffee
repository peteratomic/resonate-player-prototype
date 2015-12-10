$ = window.$ = window.jQuery = require 'jquery'
_ = window.Underscore = require 'underscore'
Backbone = require 'backbone'

module.exports = class MainView extends Backbone.View

  el: $('body')
  template: _.template '<div id="player" class="row">
      <div class="col-sm-4">
        <h2>Res(&nbsp;)nate</h2>
      </div>
      <div class="col-sm-8">
        <h2>Playlist</h2>
        <ul id="playlist">
          <%
          _.each(songs,function(song){
            %><li><%= song.fileName %></li><%
          });
          %>
        </ul>
      </div>
    </div>'

  library: null


  initialize: ->
    _.bindAll this, 'render'
    @render()


  setLibrary: (library)->
    @library = library
    library.on 'reset', @render


  render: ->

    #console.log 'rendering'
    #console.dir @library?.toJSON()

    $(@el).html @template
      songs: @library?.toJSON()

