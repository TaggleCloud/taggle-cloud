# Pull the JSON object for attendees on click
$ ->
  $("a.card").click ->
    url = @href + '.json'
    $.getJSON url, (data) ->
      alert data
      false