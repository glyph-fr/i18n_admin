module I18nAdmin
  module Errors
    class Collection < Hash
      def add(error_or_type, options = {})
        error = error_instance_from(error_or_type, options)

        self[error.type] ||= []
        self[error.type] << error
      end

      private

      def error_instance_from(error_or_type, options = {})
        if Symbol === error_or_type
          camelized = error_or_type.to_s.camelize
          type = ['I18nAdmin', 'Errors', camelized].join('::').constantize
          type.new(options)
        else
          error_or_type
        end
      end
    end
  end
end
