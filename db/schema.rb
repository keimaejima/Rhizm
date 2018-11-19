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

ActiveRecord::Schema.define(version: 2018_11_19_022927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "user_id"
    t.text "text"
    t.string "channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "stripe_plan_id"
    t.string "name"
    t.integer "amount"
    t.string "currency"
    t.string "interval"
    t.string "statement_descriptor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "present_tokens", force: :cascade do |t|
    t.integer "present_token_id"
    t.integer "receive_user_id"
    t.integer "present_user_id"
    t.integer "token_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reactions", force: :cascade do |t|
    t.string "user_id"
    t.string "reaction"
    t.string "item_user_id"
    t.string "channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stable_tokens", force: :cascade do |t|
    t.integer "stable_token_id"
    t.integer "user_id"
    t.integer "token_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer "plan_id"
    t.string "stripe_card_id"
    t.string "stripe_customer_id"
    t.string "stripe_suvscription_id"
    t.datetime "active_until", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temporary_tokens", force: :cascade do |t|
    t.integer "temporary_token_id"
    t.integer "user_id"
    t.integer "token_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "token_amount_masters", force: :cascade do |t|
    t.integer "token_amount_master_id"
    t.integer "token_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "slack_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "charge_flag"
  end

end
