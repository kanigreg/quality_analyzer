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

ActiveRecord::Schema[7.0].define(version: 2022_12_07_055759) do
  create_table "repositories", force: :cascade do |t|
    t.integer "github_id", null: false
    t.string "name"
    t.string "full_name"
    t.string "language"
    t.string "state"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_repositories_on_github_id", unique: true
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "repository_check_issues", force: :cascade do |t|
    t.string "file_path"
    t.string "message"
    t.string "rule"
    t.integer "line"
    t.integer "column"
    t.integer "repository_check_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_check_id"], name: "index_repository_check_issues_on_repository_check_id"
  end

  create_table "repository_checks", force: :cascade do |t|
    t.string "aasm_state"
    t.string "reference"
    t.boolean "passed"
    t.integer "issues_count"
    t.integer "repository_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_repository_checks_on_repository_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.string "image_url"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "repositories", "users"
  add_foreign_key "repository_check_issues", "repository_checks"
  add_foreign_key "repository_checks", "repositories"
end
