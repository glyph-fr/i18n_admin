module I18nAdmin
  module Export
    def self.types
      @types ||= {}
    end

    def self.for(format)
      types[format]
    end
  end
end

require 'i18n_admin/export/base'
require 'i18n_admin/export/xls'
