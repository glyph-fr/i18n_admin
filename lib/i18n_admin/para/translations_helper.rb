module Para
  module TranslationsHelper
    def translated_model_fields_for(model)
      model.translated_fields.map do |field_name|
        model_field_mappings(model).fields_hash[field_name]
      end.compact
    end
  end
end
