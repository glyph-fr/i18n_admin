class CreateI18nAdminResourceFiles < ActiveRecord::Migration
  def change
    create_table :i18n_admin_resource_files do |t|
      t.string :type
      t.string :job_id
      t.attachment :file

      t.timestamps null: false
    end
  end
end
