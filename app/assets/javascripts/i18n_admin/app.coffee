App = Ember.Application.create
  LOG_TRANSITIONS: true
  rootElement: 'body'

I18n = {
  locale: $('html').attr('lang')
  availableLocales: $('html').data('avaliable-locales')
}

defaultRequestOptions = ->
  @defaultOptions ?= (->
    csrfParam = $('[name="csrf-param"]').attr('content')
    csrfToken = $('[name="csrf-token"]').attr('content')
    defaultOptions = {}
    defaultOptions[csrfParam] = csrfToken
    defaultOptions
  )()

$.requestBackend = (path, options = {}) ->
  $.ajax
    url: path,
    dataType: 'json'
    type: options.type || 'get'
    data: $.extend({}, defaultRequestOptions(), options.data || {})
    headers:
      'Accept': 'application/json'

#################################
#
#          Router
#
#################################

App.Router.reopen
  rootURL: '/i18n-admin/'
  location: 'history'

App.Router.map ->
  @resource 'translations'

#################################
#
#          Routes
#
#################################

App.TranslationsRoute = Ember.Route.extend
  actions:
    changePage: (number) ->
      @set('controller.currentPage', number)
      @loadPage(number)

    changeLocale: (locale) ->
      console.log "CHANGE LOCALE", locale
      I18n.locale = locale.value
      @loadPage(@get('controller.currentPage'))

  model: ->
    page = @get('controller.currentPage') or 1
    @loadPage(page)
    Ember.A()

  loadPage: (page) ->
    options = { page: page, locale: I18n.locale }
    $.requestBackend('./translations', data: options).then (data) =>
      controller = @get('controller')
      controller.clear()

      @calculatePagesTotal(data.meta)

      data.translations.forEach (translationData) =>
        translation = App.Translation.create(translationData)
        controller.pushObject(translation)

  setupController: (controller, model) ->
    controller.set('locale', $('html').attr('lang'))
    controller.set('currentPage', 1)
    controller.set('pagesTotal', 1)
    @_super(controller, model)

  calculatePagesTotal: (data) ->
    @controller.set('pagesTotal', Math.ceil(data.count / data.per))


#################################
#
#         Controllers
#
#################################

App.TranslationsController = Ember.ArrayController.extend
  itemController: 'translation'
  locale: null
  pagesTotal: 1
  currentPage: 1

  pages: (->
    [1..@get('pagesTotal')].map (pageNumber) =>
      App.Page.create
        number: pageNumber,
        active: @get('currentPage') is pageNumber
  ).property('pagesTotal', 'currentPage')

  locales: (->
    I18n.availableLocales.map (locale) ->
      Ember.Object.create(name: locale, value: locale)
  ).property()

App.TranslationController = Ember.ObjectController.extend
  actions:
    update: ->
      @saveTranslation()

  saveTranslation: ->
    $.requestBackend(
      "./translations"
      type: 'patch'
      data:
        translation: @get('model').serialize()
    )

#################################
#
#          Models
#
#################################

App.Translation = Ember.Object.extend
  serialize: ->
    { key: @get('key'), value: @get('value') }

App.Page = Ember.Object.extend({})
