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

ActiveRecord::Schema.define(version: 20150920210833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banks", force: :cascade do |t|
    t.integer  "total_gold",   limit: 8
    t.integer  "present_gold", limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree

  create_table "competition_problems", force: :cascade do |t|
    t.integer  "problem_id"
    t.integer  "competition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "competition_problems", ["competition_id"], name: "index_competition_problems_on_competition_id", using: :btree
  add_index "competition_problems", ["problem_id", "competition_id"], name: "index_competition_problems_on_problem_id_and_competition_id", unique: true, using: :btree
  add_index "competition_problems", ["problem_id"], name: "index_competition_problems_on_problem_id", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.integer  "n_players"
    t.integer  "length"
    t.integer  "entry_gold",        default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "started_at"
    t.text     "problems_percents"
    t.boolean  "finished",          default: false
    t.integer  "target"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "message"
    t.boolean  "seen",       default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notifications", ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "problems", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "answer"
    t.integer  "creator_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "degree_of_answer"
    t.string   "units_of_answer"
    t.string   "category"
    t.integer  "difficulty"
    t.integer  "length"
    t.float    "rating"
    t.integer  "votes"
    t.integer  "target"
    t.string   "picture"
    t.boolean  "checked",          default: false
  end

  add_index "problems", ["creator_id", "created_at"], name: "index_problems_on_creator_id_and_created_at", using: :btree
  add_index "problems", ["creator_id"], name: "index_problems_on_creator_id", using: :btree

  create_table "solutions", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_problem_relation_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "answer"
    t.integer  "degree_of_answer"
    t.boolean  "reported",                 default: false
    t.integer  "upvotes",                  default: 0
    t.integer  "downvotes",                default: 0
    t.string   "picture"
  end

  add_index "solutions", ["user_problem_relation_id", "created_at"], name: "index_solutions_on_user_problem_relation_id_and_created_at", using: :btree
  add_index "solutions", ["user_problem_relation_id"], name: "index_solutions_on_user_problem_relation_id", using: :btree

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
    t.boolean  "can_see_answer",           default: false
    t.integer  "rating"
    t.integer  "length"
    t.integer  "difficulty"
    t.boolean  "voted",                    default: false
    t.boolean  "voted_solution",           default: false
    t.boolean  "solution_vote"
  end

  add_index "user_problem_relations", ["seen_problem_id"], name: "index_user_problem_relations_on_seen_problem_id", using: :btree
  add_index "user_problem_relations", ["viewer_id", "seen_problem_id"], name: "index_user_problem_relations_on_viewer_id_and_seen_problem_id", unique: true, using: :btree
  add_index "user_problem_relations", ["viewer_id"], name: "index_user_problem_relations_on_viewer_id", using: :btree

  create_table "user_solution_relations", force: :cascade do |t|
    t.integer  "viewer_id"
    t.integer  "seen_solution_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "voted",            default: false
    t.boolean  "vote"
  end

  add_index "user_solution_relations", ["seen_solution_id"], name: "index_user_solution_relations_on_seen_solution_id", using: :btree
  add_index "user_solution_relations", ["viewer_id", "seen_solution_id"], name: "index_user_solution_relations_on_viewer_id_and_seen_solution_id", unique: true, using: :btree
  add_index "user_solution_relations", ["viewer_id"], name: "index_user_solution_relations_on_viewer_id", using: :btree

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
    t.integer  "competition_id"
    t.boolean  "submitted_competition",  default: false
    t.text     "results"
    t.datetime "submitted_at"
    t.integer  "number_free_games",      default: 0
    t.integer  "number_premium_games",   default: 0
    t.boolean  "got_free_gold",          default: false
    t.integer  "times_buy_gold",         default: 0
    t.datetime "trial_started_at"
  end

  add_index "users", ["competition_id"], name: "index_users_on_competition_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "notifications", "users"
  add_foreign_key "problems", "users", column: "creator_id"
  add_foreign_key "solutions", "user_problem_relations"
  add_foreign_key "users", "competitions"
end
