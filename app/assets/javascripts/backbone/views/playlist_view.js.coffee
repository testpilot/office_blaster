class SongKick.Views.Playlist extends Backbone.View
  template: JST['backbone/templates/playlist']

  collection: null

  initialize: ->

  render: ->
    @el.html(@template(songs: @collection.toJSON()))
