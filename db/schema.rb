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

ActiveRecord::Schema.define(version: 20161025201446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_executives", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorized_accesses", force: :cascade do |t|
    t.string   "access_level"
    t.string   "backend_user_type"
    t.integer  "backend_user_id"
    t.string   "authorizable_type"
    t.integer  "authorizable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["authorizable_type", "authorizable_id"], name: "index_this_on_authorizable_type_and_id", using: :btree
    t.index ["backend_user_type", "backend_user_id"], name: "index_this_on_backend_user_type_and_id", using: :btree
  end

  create_table "client_companies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "managing"
    t.integer  "management_client_company_id"
    t.integer  "accessible_client_company_ids",              array: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["management_client_company_id"], name: "index_client_companies_on_management_client_company_id", using: :btree
    t.index ["managing"], name: "index_client_companies_on_managing", using: :btree
  end

  create_table "client_users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string   "email",             default: "", null: false
    t.string   "backend_user_type"
    t.integer  "backend_user_id"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["backend_user_type", "backend_user_id"], name: "index_identities_on_backend_user_type_and_backend_user_id", using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "property_containers", force: :cascade do |t|
    t.string   "name"
    t.integer  "client_company_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["client_company_id"], name: "index_property_containers_on_client_company_id", using: :btree
  end

end
