class I18nAdminJobMonitor
  constructor: (@$el) ->
    @initializeSidekiqJobMonitor()

  initializeSidekiqJobMonitor: ->
    @$el.sidekiqJobMonitor(onStart: @onMonitoringStart)

  onMonitoringStart: (monitor) =>
    @monitor = monitor
    @$modal = monitor.$el
    @$modal.appendTo('body').modal()
    @$modal.on('complete', @onMonitoringComplete)
    @$modal.on('hide.bs.modal', @onModalHide)
    @$modal.on('failed', @hideModal)
    @$modal.on('click', '[data-cancel="job"]', @cancelClicked)

  onMonitoringComplete: (e, monitor, data) =>
    @$modal.modal('hide')
    window.location.href = data.url

  onModalHide: (e) =>
    @cancel()

  cancelClicked: =>
    @hideModal()

  hideModal: =>
    @$modal?.modal('hide')

  cancel: ->
    @monitor.stopMonitoring()
    @monitor.cancelJob()


$(document).on 'page:change turbolinks:load', ->
  $('[data-export-link][data-remote]').each (i, el) ->
    new I18nAdminJobMonitor($(el))
