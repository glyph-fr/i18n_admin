require 'pp'

module I18nAdmin
  module Export
    class Base
      attr_reader :locale

      def self.register(type, export)
        Export.types[type] = export
      end

      private

      def translations
        @translations ||=
          translations_for_locale(locale).merge(
            models_translations_for(locale)
          )
      end

      def original_translations
        @original_translations ||=
          I18nAdmin::Translations.for_locale(I18n.default_locale).merge(
            models_translations_for(I18n.default_locale)
          )
      end

      def translations_for_locale(locale)
        I18nAdmin::Translations.for_locale(locale).select do |key, value|
          if (pattern = I18nAdmin.excluded_keys_pattern)
            !key.match(pattern)
          else
            true
          end
        end
      end

      def models_translations_for(locale)
        model_translations = {}

        I18n.with_locale(locale) do
          translated_models.each do |model, attributes|
            whitelisted_resources_for(model).includes(:translations).each do |resource|
              attributes.each do |attribute|
                key = model_translation_key_for(resource, attribute)
                model_translations[key] = resource.send(attribute).to_s
              end
            end
          end
        end

        model_translations
      end

      def model_translation_key_for(resource, attribute)
        ['models', resource.class.name, resource.id, attribute].join('-')
      end

      def translated_models
        @translated_models ||= begin
          return [] unless defined?(Globalize)

          model_names.each_with_object({}) do |model_name, models|
            begin
              model = model_name.constantize

              if model.respond_to?(:translates?) && model.translates?
                models[model] = model.translated_attribute_names
              end
            rescue LoadError
              next
            end
          end
        end
      end

      # Borrowed from Rails Admin
      def model_names
        @model_names ||=
          ([Rails.application] + Rails::Engine.subclasses.map(&:instance)).flat_map do |app|
            (app.paths['app/models'].to_a + app.config.autoload_paths).map do |load_path|
              Dir.glob(app.root.join(load_path)).map do |load_dir|
                Dir.glob(load_dir + '/**/*.rb').map do |filename|
                  next unless filename.match(/\/models\//)
                  # app/models/module/class.rb => module/class.rb => module/class => Module::Class
                  lchomp(filename, "#{app.root.join(load_dir)}/").chomp('.rb').camelize
                end
              end
            end
          end.flatten.compact.uniq
      end

      def lchomp(base, arg)
        base.to_s.reverse.chomp(arg.to_s.reverse).reverse
      end

      # If the `whitelist_models` option is set to true in the initializer,
      # only fetch the explicitly whitelisted resources for each model
      #
      def whitelisted_resources_for(model)
        if I18nAdmin.whitelist_models
          resource_id_field = [model.table_name, model.primary_key].join('.')
          model.joins(
            'INNER JOIN i18n_admin_whitelisted_resources AS whitelist ' \
            "ON whitelist.resource_id = #{ resource_id_field }"
          ).where(whitelist: { resource_type: model.name })
        else
          model
        end
      end
    end
  end
end
