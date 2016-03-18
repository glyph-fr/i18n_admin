class CreateI18nAdminWhitelistedResources < ActiveRecord::Migration
  def change
    create_table :i18n_admin_whitelisted_resources do |t|
      t.references :resource, polymorphic: true

      t.timestamps null: false
    end

    add_index :i18n_admin_whitelisted_resources, [:resource_id, :resource_type],
              name: 'whitelisted_resources_foreign_key_index'
  end
end
