module I18nAdmin
  class InstallGenerator < Rails::Generators::Base
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "I18nAdmin install generator"

    def mount_engine
      mount_path = ask(
        "Where would you like to mount I18nAdmin engine ? [/i18n-admin]"
      ).presence || '/i18n-admin'
      mount_path = mount_path.match(/^\//) ? mount_path : "/#{ mount_path }"

      gsub_file "config/routes.rb", /mount I18nAdmin.*\n/, ''

      route "mount I18nAdmin::Engine => '#{ mount_path }', as: 'i18n_admin'"
    end

    def copy_initializer
      copy_file "initializer.rb", "config/initializers/i18n_admin.rb"
    end
  end
end
