module I18nAdmin
  class TranslationsSet < ActiveRecord::Base
    validates :locale, presence: true
  end
end
