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

@removetable = (element) ->
  element.parent().parent().parent().parent('div').remove()

@tablecount = () ->
  x = []
  x.push $(i).find('tr').length-2 for i in $("#workoutforms .routineform")
  console.log(x)
  return x


$(document).ready ->
  $('#new_routine').submit ->
    x = []
    x.push $(i).find('tr').length-2 for i in $("#workoutforms .routineform")
    $('#routine_tablecount').val(x)
    