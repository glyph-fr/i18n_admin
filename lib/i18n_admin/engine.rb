module I18nAdmin
  class Engine < ::Rails::Engine
    isolate_namespace I18nAdmin

    initializer 'Configure I18n backend' do
      translations_installed = begin
        I18nAdmin::TranslationsSet.select('1').inspect
        true
      rescue
        false
      end

      table_existence = ActiveRecord::Base.connection.table_exists? 'i18n_admin_translations_sets'
      if translations_installed && table_existence
        I18n.backend = I18n::Backend::Chain.new(
          I18nAdmin::HstoreBackend.new,
          I18n.backend
        )
      end
    end
  end
end
