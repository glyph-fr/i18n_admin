class ImportProgress
  constructor: (@$el) ->
    @checkURL = @$el.data('check-url')
    @checkProgress()

  checkProgress: ->
    $.getJSON(@checkURL).then (job) =>
      switch job.state
        when 'pending' then setTimeout($.proxy(@checkProgress, this), 1000)
        when 'success' then @handleSuccess(job)
        when 'error' then @handleError(job)

  handleSuccess: (job) ->
    $('[data-status="pending"]').addClass('hidden')
    $('[data-status="success"]').removeClass('hidden')

  handleError: (job) ->
    $('[data-status="pending"]').addClass('hidden')
    $('[data-status="error"]').removeClass('hidden')

$(document).on 'page:change', ->
  if ($importProgress = $('[data-processing-import]')).length
    new ImportProgress($importProgress)
