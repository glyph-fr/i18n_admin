require 'kaminari'
require 'request_store'
require 'spreadsheet'
require 'active_model'
require 'turbolinks'
require 'nprogress-rails'
require 'sucker_punch'
require 'para'
require 'active_record'

require "i18n_admin/request_store"
require "i18n_admin/hstore_backend"
require "i18n_admin/translations"
require "i18n_admin/translation_collection"
require "i18n_admin/translation"

require "i18n_admin/errors"
require "i18n_admin/export"
require "i18n_admin/import"

require "i18n_admin/model"

require "i18n_admin/engine"

module I18nAdmin
  mattr_accessor :authentication_method
  @@authentication_method = :authenticate_user!

  mattr_accessor :current_user_method
  @@current_user_method = :current_user

  mattr_accessor :excluded_keys_pattern
  @@excluded_keys_pattern = nil

  mattr_accessor :whitelist_models
  @@whitelist_models = false

  def self.config(&block)
    block_given? ? yield(self) : self
  end
end

Mime::Type.register "application/xls", :xls
