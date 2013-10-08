# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  inst = Math.floor((Math.random() * 4) + 1)
  $('.note').data('instrument', inst)
  $('.container').addClass('instrument-' + inst)

  $('.note').on "click", ->
      signal = [$(this).data('note'), $(this).data('instrument')]
      alert(signal)