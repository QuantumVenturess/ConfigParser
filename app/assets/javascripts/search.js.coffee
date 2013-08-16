$(document).ready ->
  source = $('.search input').data('source')
  fetchParameters = (q) ->
    $.ajax
      data:
        q: q
      dataType: 'script'
      url     : source
  fetchParameters()
  $('.search input').keyup ->
    text = $(@).val()
    fetchParameters text
    if text.length > 0
      $('.search .cancel').show()
    else
      $('.search .cancel').hide()

  $(document).on 'click', '.search .cancel', ->
    $(@).hide()
    fetchParameters()
    $('.search input').val('').focus()
    no