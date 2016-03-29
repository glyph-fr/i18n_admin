module I18nAdmin
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :translated_fields
    end

    def read_translated_attribute(field, locale = I18n.locale)
      return read_attribute(field) if locale == I18n.default_locale

      if _translations && _translations[locale.to_s]
        _translations[locale.to_s][field.to_s]
      end
    end

    def write_translated_attribute field, value, locale = I18n.locale
      return write_attribute(field, value) if locale == I18n.default_locale

      self._translations ||= {}
      _translations[locale.to_s] ||= {}
      _translations[locale.to_s][field.to_s] = value
    end

    module ClassMethods
      def translates(*fields)
        self.translated_fields = fields.with_indifferent_access

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
