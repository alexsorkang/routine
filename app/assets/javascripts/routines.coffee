# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@addexercise = (element) ->
  $copy = $("#newexerciseform").children().clone(true,true)
  element.parent().parent('tr').before($copy)

@addday = (element) ->
  $copy = $("#newdayform").children().clone(true,true)
  $("#workoutforms").append($copy)


@removeexercise = (element) ->
  element.parent('tr').remove()