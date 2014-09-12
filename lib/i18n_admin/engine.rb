module I18nAdmin
  class Engine < ::Rails::Engine
    isolate_namespace I18nAdmin

    initializer 'Configure I18n backend with the given key_value_store' do
      translations_installed = begin
        I18nAdmin::TranslationsSet.select('1').inspect
        true
      rescue
        false
      end

      if translations_installed
        I18n.backend = I18n::Backend::Chain.new(
          I18nAdmin::HstoreBackend.new,
          I18n.backend
        )
      end
    end
  end
end
