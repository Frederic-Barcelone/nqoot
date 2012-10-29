# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#add-question').click (e) ->
    e.preventDefault()
    question = $('#question-title').val()
    description = $('#question-desc').val()
    anonimity = false
    if $('#anon-post').attr('checked') == 'checked'
      anonimity = true
    query = 'question=' + question + '&description=' + description + '&anonimity=' + anonimity + '&slug=' + slug(question)
    url = 'http://nqoot.francis.ph/add/question'
    $.ajax
      type: 'POST'
      url: url
      data: query
      success: (data, code, xmlhttp) ->
        window.location = xmlhttp.responseText