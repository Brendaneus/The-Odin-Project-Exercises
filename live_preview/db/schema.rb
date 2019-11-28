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

ActiveRecord::Schema.define(version: 2019_11_21_110537) do

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "source"
    t.string "tutorial"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.integer "course_id"
    t.string "name"
    t.text "notes"
    t.string "tutorial"
    t.string "source"
    t.string "url"
    t.boolean "complete", default: true
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["course_id"], name: "index_projects_on_course_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  add_foreign_key "projects", "courses"
end
