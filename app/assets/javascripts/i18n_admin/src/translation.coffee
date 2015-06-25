class Translation
  constructor: (@$el) ->
    @initialize()

  initialize: ->
    @$form = @$el.find('[data-translation-form]')
    @$field = @$el.find('[data-translation-field]')
    @currentValue = @$field.val()

    @$field.on('blur', $.proxy(@updateTranslation, this))
    @$form.on('ajax:beforeSend', $.proxy(@onBeforeSend, this))
    @$form.on('ajax:complete', $.proxy(@onSaveComplete, this))
    @$form.on('ajax:success', $.proxy(@translationSaved, this))

    @$field.autoGrow()

  updateTranslation: ->
    if (newValue = @$field.val()) != @currentValue
      @currentValue = newValue
      @$form.submit()

  translationSaved: (e, response) ->
    @onSaveComplete()

    $newMarkup = $(response)
    @$el.html($newMarkup.html())

    @initialize()
    @showSuccess()

  onBeforeSend: ->
    NProgress.start()
    @$el.addClass('loading')

  onSaveComplete: ->
    NProgress.done()
    @$el.removeClass('loading')

  showSuccess: ->
    @$field.addClass('success')
    setTimeout (=> @$field.removeClass('success')), 1000

$(document).on 'page:change', ->
  if ($translations = $('[data-translation]')).length
    $translations.each (i, el) -> new Translation($(el))
