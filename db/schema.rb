# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_29_140422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contests", force: :cascade do |t|
    t.string "display_name"
    t.text "content"
    t.boolean "registration_open", default: false, null: false
    t.boolean "task_open", default: false, null: false
    t.boolean "upload_open", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.string "registration_secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cities", default: [], null: false, array: true
    t.string "contest_sites", default: [], null: false, array: true
    t.string "judge_password", null: false
    t.boolean "archive_open", default: false, null: false
  end

  create_table "results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.float "score", default: 0.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_results_on_task_id"
    t.index ["user_id", "task_id"], name: "index_results_on_user_id_and_task_id", unique: true
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.inet "ips", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "upload_number", default: 1, null: false
    t.index ["task_id"], name: "index_solutions_on_task_id"
    t.index ["user_id", "task_id", "upload_number"], name: "index_solutions_on_user_id_and_task_id_and_upload_number", unique: true
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "display_name"
    t.string "file_names", default: [], null: false, array: true
    t.integer "upload_limit", default: 1, null: false
    t.bigint "contest_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contest_id"], name: "index_tasks_on_contest_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "contest_id", null: false
    t.citext "name"
    t.citext "email"
    t.string "region"
    t.string "city"
    t.string "institution"
    t.string "contest_site"
    t.integer "grade"
    t.string "secret"
    t.inet "registration_ips", default: [], null: false, array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contest_id", "secret"], name: "index_users_on_contest_id_and_secret"
    t.index ["contest_id"], name: "index_users_on_contest_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "results", "tasks"
  add_foreign_key "results", "users"
  add_foreign_key "solutions", "tasks"
  add_foreign_key "solutions", "users"
  add_foreign_key "tasks", "contests"
  add_foreign_key "users", "contests"
end
