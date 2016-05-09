module I18nAdmin
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :translated_fields
    end

    def read_translated_attribute(field, locale = I18n.locale)
      return read_attribute(field) if locale == I18n.default_locale

      if model_translations[locale.to_s]
        if (translation = model_translations[locale.to_s][field.to_s])
          return translation
        end
      end

      # If no translation was returned, try to fallback to the next locale
      if (fallback_locale = i18n_fallback_for(locale))
        read_translated_attribute(field, fallback_locale)
      end
    end

    def write_translated_attribute field, value, locale = I18n.locale
      return write_attribute(field, value) if locale == I18n.default_locale

      model_translations[locale.to_s] ||= {}
      model_translations[locale.to_s][field.to_s] = value
    end

    def model_translations
      unless respond_to?(:_translations)
        raise "The model #{ self.class.name } is not translatable. " +
              "Please run `rails g i18n_admin:translate #{ self.model_name.element }` " +
              "generator to create the model's migration."
      end

      self._translations ||= {}
    end

    def i18n_fallback_for(locale)
      return unless I18n.respond_to?(:fallbacks)

      if (fallbacks = I18n.fallbacks[locale]) && fallbacks.length > 1
        fallbacks[1]
      else
        I18n.default_locale
      end
    end

    module ClassMethods
      def translates(*fields)
        self.translated_fields = fields.map(&:to_sym)

        fields.each do |field|
          define_method field do
            read_translated_attribute(field)
          end

          define_method :"#{ field }=" do |value|
            write_translated_attribute(field, value)
          end
        end
      end
    end
  end
end
