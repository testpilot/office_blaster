#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.SongKick =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  bootstrap: ->
    SongKick.applicationView = new SongKick.Views.ApplicationView
    #Backbone.history.start()
