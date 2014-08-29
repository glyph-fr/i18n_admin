module I18nAdmin
  class HstoreBackend
    def [](path)
      locale, key = locale_and_key_from(path)
      cached_translations_for(locale).translations[key]
    end

    def []=(path, value)
      locale, key = locale_and_key_from(path)
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

    def keys
      raise "CALLED KEYS METHOD"
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
end
