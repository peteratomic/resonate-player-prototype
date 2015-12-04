$ = window.jQuery = require 'jquery'
_ = window.Underscore = require 'underscore'
Backbone = require 'backbone'

module.exports = class MainView extends Backbone.View

  el: $('body')
  template: _.template($('script#main').html())

  initialize: ->
    _.bindAll this, 'render'
    @render()

  render: ->

    $(@el).html @template()

