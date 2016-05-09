module I18nAdmin
  class Engine < ::Rails::Engine
    isolate_namespace I18nAdmin

    initializer 'i18n_admin.configure_i18n_backend' do
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

    initializer 'i18n_admin.include_model_extension_into_active_record' do
      ActiveSupport.on_load(:active_record) do
        include I18nAdmin::Model
      end
    end

    initializer 'i18n_admin.extend_para_routes' do
      Para.config.routes.extend_routes_for(:crud_component) do
        resource :translation, only: [:edit, :update]
      end
    end

    initializer 'i18n_admin.include_view_helpers' do
      ActiveSupport.on_load(:action_view) do
        include Para::TranslationsHelper
      end
    end
  end
end
