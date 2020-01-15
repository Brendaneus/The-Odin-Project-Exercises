# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_09_044545) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "title"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "picture_id", null: false
    t.integer "character_id", null: false
    t.float "left_coord"
    t.float "right_coord"
    t.float "top_coord"
    t.float "bottom_coord"
    t.string "hint"
    t.index ["character_id"], name: "index_locations_on_character_id"
    t.index ["picture_id"], name: "index_locations_on_picture_id"
  end

  create_table "locations_scores", id: false, force: :cascade do |t|
    t.integer "score_id", null: false
    t.integer "location_id", null: false
    t.index ["score_id", "location_id"], name: "index_locations_scores_on_score_id_and_location_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.integer "album_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_pictures_on_album_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "user_id"
    t.integer "picture_id", null: false
    t.datetime "last_active"
    t.integer "elapsed_time", default: 0
    t.boolean "finished", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["picture_id"], name: "index_scores_on_picture_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "locations", "characters"
  add_foreign_key "locations", "pictures"
  add_foreign_key "pictures", "albums"
  add_foreign_key "scores", "pictures"
  add_foreign_key "scores", "users"
end
