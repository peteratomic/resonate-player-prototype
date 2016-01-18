$ = window.jQuery = require 'jquery'
_ = window.Underscore = require 'underscore'
Backbone = require 'backbone'

module.exports = class Song extends Backbone.Model

  initialize: ->

    if !@attributes.title
      @attributes.title = 'Untitled'
      @attributes.album = 'Unknown album'
      @attributes.artist = 'Unknown artist'

