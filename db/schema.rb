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

ActiveRecord::Schema.define(version: 20150815110747) do

  create_table "notifications", force: :cascade do |t|
    t.string   "message"
    t.boolean  "seen",       default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notifications", ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at"
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "problems", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "answer"
    t.integer  "creator_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "degree_of_answer"
    t.string   "units_of_answer"
    t.string   "category"
    t.integer  "difficulty"
    t.integer  "length"
  end

  add_index "problems", ["creator_id", "created_at"], name: "index_problems_on_creator_id_and_created_at"
  add_index "problems", ["creator_id"], name: "index_problems_on_creator_id"

  create_table "solutions", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_problem_relation_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "answer"
    t.integer  "degree_of_answer"
    t.boolean  "reported",                 default: false
  end

  add_index "solutions", ["user_problem_relation_id", "created_at"], name: "index_solutions_on_user_problem_relation_id_and_created_at"
  add_index "solutions", ["user_problem_relation_id"], name: "index_solutions_on_user_problem_relation_id"

  create_table "user_problem_relations", force: :cascade do |t|
    t.integer  "viewer_id"
    t.integer  "seen_problem_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "rated",                    default: false
    t.boolean  "attempted_during_free",    default: false
    t.boolean  "attempted_during_premium", default: false
    t.boolean  "solved_during_free",       default: false
    t.boolean  "solved_during_premium",    default: false
    t.boolean  "provided_with_solution",   default: false
    t.boolean  "can_see_solution",         default: false
  end

  add_index "user_problem_relations", ["seen_problem_id"], name: "index_user_problem_relations_on_seen_problem_id"
  add_index "user_problem_relations", ["viewer_id", "seen_problem_id"], name: "index_user_problem_relations_on_viewer_id_and_seen_problem_id", unique: true
  add_index "user_problem_relations", ["viewer_id"], name: "index_user_problem_relations_on_viewer_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "age"
    t.string   "country"
    t.string   "school_name"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.integer  "free_level",             default: 2000
    t.integer  "premium_level",          default: 2000
    t.integer  "gold",                   default: 0
    t.boolean  "admin",                  default: false
    t.boolean  "moderator",              default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid"

end
