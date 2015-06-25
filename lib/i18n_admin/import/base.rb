module I18nAdmin
  module Import
    class Base
      attr_reader :locale

      def self.register(type, import)
        Import.types[type] = import
      end

      def errors
        @errors ||= I18nAdmin::Errors::Collection.new
      end

      private

      def save_updated_models
        # Save all updated model translations
        ActiveRecord::Base.transaction do
          updated_models.each do |key, resource|
            unless resource.save
              errors.add(:resource_invalid, key: key, resource: resource)
            end
          end
        end
      end

      def update_translation(key, value)
        case key
        when /^models\-/ then update_model_translation(key, value)
        else update_static_translation(key, value)
        end
      end

      def update_model_translation(key, value)
        _, model_name, id, field = key.split('-')
        update_cache_key = [model_name, id].join('-')

        # Find resource from update cache, or in database
        unless (resource = updated_models[update_cache_key])
          model = model_name.constantize
          resource = model.where(id: id).first
        end

        # Only update found resources
        if resource
          resource.send(:"#{ field }=", value)
          updated_models[update_cache_key] ||= resource
        else
          errors.add(:resource_not_found, {
            key: update_cache_key, model_name: model_name, id: id
          })
        end
      end

      def update_static_translation(key, value)
        I18n.backend.store_translations(locale, key => value)
      end

      def updated_models
        @updated_models ||= {}
      end
    end
  end
end
