module I18nAdmin
  class Translations
    include I18nAdmin::RequestStore

    def self.translations_for(locale)
      translations = TranslationCollection.new

      for_locale(locale).each do |key, value|
        translations << Translation.new(
          key: key,
          original: for_locale(I18n.default_locale)[key],
          value: value,
          locale: locale
        )
      end

      translations
    end

    def self.for_locale(locale)
      new.for_locale(locale.to_sym)
    end

    # Save a translation object
    def self.update(translation)
      I18n.backend.store_translations(
        translation.locale,
        translation.key => translation.value
      )

      if translation.locale == I18n.default_locale
        translation.original = translation.value
      end
    end

    def for_locale(locale = I18n.locale)
      translations = with_empty_keys_for(locale, all_translations_for(locale))

      translations.keys.sort.each_with_object({}) do |key, hash|
        hash[key] = translations[key]
      end
    end

    def all_translations_for(locale)
      request_store.store[store_key_for(locale, :hash)] ||= backends.map do |backend|
        translations_for(locale, backend)
      end.reduce(&:reverse_merge)
    end

    def backends
      @backends ||= I18n.backend.backends
    end

    def translations_for(locale, backend)
      translations = if backend.protected_methods.include?(:translations)
        parse_from_deep_hash(locale, backend.send(:translations))
      elsif backend.respond_to?(:store)
        backend.store.translations_for(locale)
      end
    end

    def parse_from_deep_hash(locale, translations)
      flatten_translation_hash(translations[locale] || {})
    end

    def flatten_translation_hash(hash, scope = nil, translations = {})
      hash.each_with_object(translations) do |(key, value), buffer|
        scoped_key = [scope, key.to_s].compact.join('.')

        if value.is_a?(Hash)
          flatten_translation_hash(value, scoped_key, buffer)
        elsif elegible_key?(scoped_key)
          buffer[scoped_key] = value
        end
      end
    end

    def elegible_key?(key)
      if (pattern = I18nAdmin.excluded_keys_pattern)
        !key.match(pattern)
      else
        true
      end
    end

    def with_empty_keys_for(locale, hash)
      return hash if I18n.default_locale == locale

      all_translations_for(I18n.default_locale).keys.each do |key|
        hash[key] = "" unless hash.key?(key)
      end

      hash
    end
  end
end
