# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160404161658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "i18n_admin_import_jobs", force: :cascade do |t|
    t.string   "locale"
    t.text     "filename"
    t.string   "state",      default: "pending"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "i18n_admin_resource_files", force: :cascade do |t|
    t.string   "type"
    t.string   "job_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "i18n_admin_translations_sets", force: :cascade do |t|
    t.string   "locale"
    t.hstore   "translations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "i18n_admin_whitelisted_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "i18n_admin_whitelisted_resources", ["resource_id", "resource_type"], name: "whitelisted_resources_foreign_key_index", using: :btree

  create_table "para_component_resources", force: :cascade do |t|
    t.integer  "component_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "para_component_resources", ["component_id"], name: "index_para_component_resources_on_component_id", using: :btree
  add_index "para_component_resources", ["resource_type", "resource_id"], name: "index_para_component_resources_on_resource_type_and_resource_id", using: :btree

  create_table "para_component_sections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier"
    t.integer  "position"
  end

  create_table "para_components", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.hstore   "configuration",        default: {}, null: false
    t.integer  "position",             default: 0
    t.integer  "component_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "identifier"
  end

  add_index "para_components", ["slug"], name: "index_para_components_on_slug", using: :btree

  add_foreign_key "para_component_resources", "para_components", column: "component_id"
end
