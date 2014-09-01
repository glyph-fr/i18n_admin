require 'i18n/backend/key_value'

module I18nAdmin
  class HstoreBackend < I18n::Backend::KeyValue
    class Store
      def [](path)
        locale, key = locale_and_key_from(path)
        cached_translations_for(locale).translations[key]
      end

      def store_translations(locale, key, value)
        translations_set = translations_set_for(locale)
        translations_set.translations[key] = value
        translations_set.translations_will_change!
        translations_set.save
        @cached_translations_for[locale] = translations_set
        value
      end

      def translations_for(locale)
        translations_set_for(locale).translations
      end

      private

      def locale_and_key_from(path)
        path.split('.', 2)
      end

      def translations_set_for(locale)
        model.where(locale: locale).first_or_initialize do |set|
          set.translations ||= {}
        end
      end

      def cached_translations_for(locale)
        @cached_translations_for ||= {}
        @cached_translations_for[locale] ||= translations_set_for(locale)
      end

      def model
        @model ||= I18nAdmin::TranslationsSet
      end
    end

    def initialize
      @store = HstoreBackend::Store.new
    end

    def store_translations(locale, data, options = {})
      data.each do |key, value|
        store.store_translations(locale, key, value)
      end
    end

    protected

    def lookup(locale, key, scope = [], options = {})
      key = normalize_flat_keys(locale, key, scope, options[:separator])
      store["#{locale}.#{key}"]
    end
  end
end
