require 'i18n/backend/key_value'

module I18nAdmin
  class HstoreBackend < I18n::Backend::KeyValue
    def available_locales
      @available_locales ||= I18nAdmin::TranslationsSet.pluck(:locale)
    end

    class Store
      include I18nAdmin::RequestStore

      def [](path)
        locale, key = locale_and_key_from(path)
        cached_translations_for(locale).translations[key]
      end

      def store_translations(locale, key, value)
        translations_set = translations_set_for(locale)
        translations_set.translations[key] = value
        translations_set.translations_will_change!
        translations_set.save
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
        store_key = store_key_for(locale, :set)
        request_store.store[store_key] ||= translations_set_for(locale)
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
