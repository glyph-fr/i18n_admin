class CreateI18nAdminImportJobs < ActiveRecord::Migration
  def change
    create_table :i18n_admin_import_jobs do |t|
      t.string :locale
      t.text :filename
      t.string :state, default: 'pending'

      t.timestamps null: false
    end
  end
end
