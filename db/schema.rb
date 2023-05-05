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

ActiveRecord::Schema.define(version: 20131124212424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "foods", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "weight", limit: 40
    t.string "measure", limit: 40
    t.integer "kcal"
    t.string "kind", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "suggester_id"
  end

  create_table "user_foods", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "food_id"
    t.float "amount"
    t.string "meal", limit: 20
    t.date "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "kcal"
    t.index ["date", "meal"], name: "index_user_foods_on_date_and_meal"
    t.index ["user_id", "date"], name: "index_user_foods_on_user_id_and_date"
  end

  create_table "user_friends", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "friend_name"
    t.string "friend_email"
    t.date "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "msg"
  end

  create_table "user_weights", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.float "weight"
    t.date "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "cpf"
    t.string "address_street_and_number"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zipcode"
    t.integer "kcal_limit"
    t.boolean "subscribed_daily", default: false
    t.datetime "deleted_at"
    t.boolean "subscribed_weekly", default: true
    t.integer "status"
    t.string "bank_billet_link"
    t.date "expire_at"
    t.integer "bank_billet_id"
    t.string "bank_billet_our_number"
    t.string "paypal_email"
    t.date "subscribed_at"
    t.string "nutri_email"
    t.string "nutri_name"
    t.string "referred_by_email"
    t.string "phone"
    t.boolean "subscribed_newsletter", default: true
    t.string "bank_billet_our_number_6"
    t.string "bank_billet_link_6"
    t.string "bank_billet_our_number_12"
    t.string "bank_billet_link_12"
    t.date "renew_at"
    t.date "bank_billet_expire_at"
    t.boolean "small_portions"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
