class CreateI18nAdminTranslationsSets < ActiveRecord::Migration
  def change
    enable_extension :hstore

    create_table :i18n_admin_translations_sets do |t|
      t.string :locale
      t.hstore :translations

      t.timestamps
    end
  end
end
