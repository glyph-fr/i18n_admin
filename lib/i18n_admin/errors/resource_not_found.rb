module I18nAdmin
  module Errors
    class ResourceNotFound < Errors::Base
      attr_accessor :key, :model_name, :id
    end
  end
end
