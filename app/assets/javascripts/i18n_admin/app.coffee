Ember.RSVP.on 'error', (error) ->
  console.assert(false, error)
  console.error(error.stack) if (error && error.stack)


window.App = Ember.Application.create
  LOG_TRANSITIONS: true
  rootElement: 'body'

I18n = {
  locale: $('html').attr('lang')
  defaultLocale: $('html').data('default-locale')
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

  $.extend({}, @defaultOptions, locale: I18n.locale)

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
      I18n.locale = locale.value
      @set('controller.currentLocale', locale.value)
      @loadPage(@get('controller.currentPage'))

    search: ->
      @set('controller.currentPage', 1)
      @loadPage(1)

  model: ->
    page = @get('controller.currentPage') or 1
    @loadPage(page)
    Ember.A()

  loadPage: (page) ->
    options = { page: page }

    if (searchTerms = @get('controller.searchTerms'))
      $.extend(options, q: searchTerms)

    if (controller = @get('controller'))
      controller.set('isLoading', true)

    $.requestBackend('./translations', data: options).then (data) =>
      controller = @get('controller')
      controller.clear()

      controller.set('isLoading', false)

      controller.set('per', data.meta.per)
      controller.set('totalCount', data.meta.count)
      @calculatePagesTotal(data.meta)

      data.translations.forEach (translationData) =>
        translation = App.Translation.create(translationData)
        controller.pushObject(translation)

  setupController: (controller, model) ->
    controller.set('isLoading', true)
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
  isLoading: false
  itemController: 'translation'
  locale: null
  pagesTotal: 0
  currentPage: 0
  totalCount: 0
  per: 0
  searchTerms: ''

  pages: (->
    [1..@get('pagesTotal')].map (pageNumber) =>
      App.Page.create
        number: pageNumber,
        active: @get('currentPage') is pageNumber
  ).property('pagesTotal', 'currentPage')

  locales: (->
    I18n.availableLocales.map (locale) =>
      Ember.Object.create(
        name: locale
        value: locale
        isCurrentLocale: locale is (@get('currentLocale') or I18n.locale)
      )
  ).property('currentLocale')

  defaultLocale: (->
    I18n.defaultLocale
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
#          Views
#
#################################

App.AutoGrowTextArea = Ember.TextArea.extend
  didInsertElement: ->
    console.log 'autoGrow', @$()
    @$().autoGrow()


#################################
#
#          Models
#
#################################

App.Translation = Ember.Object.extend
  serialize: ->
    { key: @get('key'), value: @get('value') }

App.Page = Ember.Object.extend({})

App.Locale = Ember.Object.extend({})
