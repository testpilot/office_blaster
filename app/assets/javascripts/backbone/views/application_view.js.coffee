class SongKick.Views.ApplicationView extends Backbone.View

  template: JST['backbone/templates/application']

  initialize: ->
    @render()

  render: ->
    $('body').append(@template())
