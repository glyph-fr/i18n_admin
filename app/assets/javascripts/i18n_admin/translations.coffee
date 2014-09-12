htmlTag = document.getElementsByTagName('html')[0]
Em.I18n.defaultLocale = htmlTag.getAttribute('lang')

locales =
  fr:
    'i18n_admin.translations.title': 'Traductions'
    'i18n_admin.translations.choose_locale': 'Choisissez la langue à traduire :'
    'i18n_admin.translations.search': 'Rechercher'
    'i18n_admin.translations.loading': 'Chargement des traductions ...'
    'i18n_admin.translation_set.key': 'Clé'
    'i18n_admin.translation_set.original': 'Original ({{locale}})'
    'i18n_admin.translation_set.translation': 'Traduction'

  en:
    'i18n_admin.translations.title': 'Translations'
    'i18n_admin.translations.choose_locale': 'Choose locale to translate :'
    'i18n_admin.translations.search': 'Search'
    'i18n_admin.translations.loading': 'Loading translations ...'
    'i18n_admin.translation_set.key': 'Key'
    'i18n_admin.translation_set.original': 'Original ({{locale}})'
    'i18n_admin.translation_set.translation': 'Translation'

Em.I18n.translations = locales[Em.I18n.defaultLocale] || locales.en

