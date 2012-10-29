jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()


# Pull the JSON object for attendees on click
$ ->
  $("a.card").click ->
    # Set up variables for future use
    card = $(@)
    li = card.parent()
    url = @.href + '.json'
    
    # Check if we've already grabbed the JSON, if not go grab it and add it in
    if (card.children(".abstract").length == 0)
      $.getJSON url, (data) ->
          abstracts = $(data.abstracts)
          abstracts.each (index) ->
            card.append('<p class="abstract" style="display: none">' + abstracts[index].body + '</p>')

    # Toggle expansion/contraction
    if (li.hasClass("span6"))
      li.switchClass "span6", "span12", 500, ->
        card.children(".abstract").show("fast")
    else if (card.children(".abstract").length > 0)
      card.children(".abstract").hide "fast", ->
        li.switchClass "span12", "span6", 500
    else
      li.switchClass "span12", "span6", 500

    # Don't follow the link
    false
