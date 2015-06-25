module I18nAdmin
  module Errors
    class ResourceInvalid < Errors::Base
      attr_accessor :key, :resource
    end
  end
end
