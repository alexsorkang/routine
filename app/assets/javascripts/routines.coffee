# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@addexercise = (element) ->
  $copy = $("#newexerciseform").children().clone(true,true)
  console.log($copy.html())
  element.parent().parent('tr').before($copy)

@removeexercise = (element) ->
  element.parent('tr').remove()