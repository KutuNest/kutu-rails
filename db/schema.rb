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

ActiveRecord::Schema.define(version: 20170427045918) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "member_id"
    t.string   "name"
    t.date     "arrival_date"
    t.boolean  "admin_account"
    t.boolean  "super_user"
    t.boolean  "action_available"
    t.boolean  "kicked_out"
    t.integer  "number_associations_left"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "groupement_id"
    t.integer  "pool_id"
    t.integer  "pool_order"
    t.boolean  "has_finished"
    t.index ["groupement_id"], name: "index_accounts_on_groupement_id"
    t.index ["member_id", "name"], name: "index_accounts_on_member_id_and_name", unique: true
    t.index ["member_id"], name: "index_accounts_on_member_id"
    t.index ["pool_id"], name: "index_accounts_on_pool_id"
  end

  create_table "accounts_transactions", id: false, force: :cascade do |t|
    t.integer "account_id",     null: false
    t.integer "transaction_id", null: false
  end

  create_table "banks", force: :cascade do |t|
    t.string   "title"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_banks_on_country_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "title"
    t.string   "name"
    t.string   "tld"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groupements", force: :cascade do |t|
    t.boolean  "activated_on_create"
    t.integer  "initial_accounts"
    t.integer  "maximum_accounts"
    t.integer  "accounts_added_on_success"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
  end

  create_table "members", force: :cascade do |t|
    t.string   "username"
    t.string   "account_holder_name"
    t.string   "account_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.integer  "country_id"
    t.integer  "bank_id"
    t.boolean  "sms_notification"
    t.boolean  "email_notification"
    t.integer  "accounts_limit"
    t.integer  "groupement_id"
    t.string   "referral_code"
    t.string   "referrer_code"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["groupement_id"], name: "index_members_on_groupement_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "transaction_id"
    t.integer  "account_id"
    t.string   "receiver_email"
    t.string   "receiver_mobile_number"
    t.string   "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "notification_event"
    t.integer  "member_id"
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["transaction_id"], name: "index_notifications_on_transaction_id"
  end

  create_table "pools", force: :cascade do |t|
    t.integer  "groupement_id"
    t.string   "title"
    t.integer  "amount"
    t.integer  "position"
    t.integer  "feeders_count"
    t.integer  "timeout"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["groupement_id"], name: "index_pools_on_groupement_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "eater_id"
    t.integer  "feeder_id"
    t.date     "completed_date"
    t.integer  "value"
    t.integer  "timeout"
    t.boolean  "sender_confirmed"
    t.boolean  "receiver_confirmed"
    t.boolean  "failed"
    t.boolean  "admin_confirmed"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "sender_receipt"
    t.boolean  "disputed"
    t.integer  "pool_id"
    t.index ["pool_id"], name: "index_transactions_on_pool_id"
  end

end
