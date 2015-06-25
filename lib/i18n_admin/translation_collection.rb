module I18nAdmin
  class TranslationCollection
    include Enumerable

    attr_writer :translations

    delegate :<<, :each, :[], :[]=, to: :translations

    def translations
      @translations ||= []
    end

    def page(page_index)
      Kaminari.paginate_array(self).page(page_index)
    end

    def search(query)
      regex = /#{ query.split(' ').join('|') }/i

      # Duplicate and filter translations
      updated = dup
      updated.translations.select! { |translation| translation.matches?(regex) }
      updated
    end

    def find(encoded_key)
      key = I18nAdmin::Translation.key_from(encoded_key)

      translations.find do |translation|
        translation.key == key
      end
    end
  end
end
