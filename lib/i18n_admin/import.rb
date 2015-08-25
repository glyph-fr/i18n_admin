module I18nAdmin
  module Import
    def self.types
      @types ||= {}
    end

    def self.for(format)
      types[format]
    end
  end
end

require 'i18n_admin/import/base'
require 'i18n_admin/import/xls'

require 'i18n_admin/import/job'
