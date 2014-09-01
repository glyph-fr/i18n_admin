require 'kaminari'
require 'ember-rails'
require 'request_store'

require "i18n_admin/hstore_backend"
require "i18n_admin/translations"
require "i18n_admin/engine"

module I18nAdmin
  mattr_accessor :authentication_method
  @@authentication_method = :authenticate_user!

  mattr_accessor :current_user_method
  @@current_user_method = :current_user

  mattr_accessor :key_value_store
  @@key_value_store = {}

  mattr_accessor :excluded_keys_pattern
  @@excluded_keys_pattern = nil

  def self.config(&block)
    block_given? ? yield(self) : self
  end
end
