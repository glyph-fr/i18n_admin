module I18nAdmin
  class Engine < ::Rails::Engine
    isolate_namespace I18nAdmin

    initializer 'Configure I18n backend with the given key_value_store' do
      I18n.backend = I18n::Backend::Chain.new(
        I18nAdmin::HstoreBackend.new,
        I18n.backend
      )
    end
  end
end
