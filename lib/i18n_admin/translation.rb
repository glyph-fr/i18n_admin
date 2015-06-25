require 'base64'

module I18nAdmin
  class Translation
    include ActiveModel::Model

    attr_accessor :key, :original, :value, :locale

    def persisted?
      true
    end

    def to_param
      Base64.strict_encode64(key)
    end

    def matches?(search)
      [:key, :original, :value].any? do |key|
        send(key).to_s.match(search)
      end
    end

    def self.key_from(encoded_key)
      Base64.decode64(encoded_key)
    end
  end
end
