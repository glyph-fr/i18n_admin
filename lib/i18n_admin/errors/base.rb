module I18nAdmin
  module Errors
    class Base
      def initialize(attributes = {})
        assign_attributes(attributes)
      end

      def assign_attributes(attributes = {})
        attributes.each do |key, value|
          public_send(:"#{ key }=", value)
        end
      end

      def messages
        @messages ||= []
      end

      def type
        self.class.name.demodulize.underscore.to_sym
      end
    end
  end
end
