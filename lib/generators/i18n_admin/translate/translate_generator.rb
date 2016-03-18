require 'rails/generators/active_record/migration'

module I18nAdmin
  class TranslateGenerator < Rails::Generators::NamedBase
   include Rails::Generators::Migration
   include ActiveRecord::Generators::Migration

    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    class_option :migrate, type: :boolean, default: false, :aliases => "-m"

    # Generator desc
    desc "I18nAdmin translation generator"

    def generate_migration
      migration_template 'model_migration.rb.erb', "db/migrate/translate_#{ file_name }.rb"
    end

    def migrate
      rake 'db:migrate' if options[:migrate]
    end
  end
end
