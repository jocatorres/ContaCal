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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121102232228) do

  create_table "foods", :force => true do |t|
    t.string   "name"
    t.string   "weight",       :limit => 40
    t.string   "measure",      :limit => 40
    t.integer  "kcal"
    t.string   "kind",         :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "suggester_id"
  end

  create_table "user_foods", :force => true do |t|
    t.integer  "user_id"
    t.integer  "food_id"
    t.float    "amount"
    t.string   "meal",       :limit => 20
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "kcal"
  end

  add_index "user_foods", ["date", "meal"], :name => "index_user_foods_on_date_and_meal"
  add_index "user_foods", ["user_id", "date"], :name => "index_user_foods_on_user_id_and_date"

  create_table "users", :force => true do |t|
    t.string   "email",                                    :default => "",    :null => false
    t.string   "encrypted_password",        :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.string   "cpf"
    t.string   "address_street_and_number"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zipcode"
    t.integer  "kcal_limit"
    t.boolean  "subscribed_daily",                         :default => false
    t.datetime "deleted_at"
    t.boolean  "subscribed_weekly",                        :default => true
    t.integer  "status"
    t.string   "bank_billet_link"
    t.date     "expire_at"
    t.integer  "bank_billet_id"
    t.string   "bank_billet_our_number"
    t.string   "paypal_email"
    t.date     "subscribed_at"
    t.string   "nutri_email"
    t.string   "nutri_name"
    t.string   "referred_by_email"
    t.string   "phone"
    t.boolean  "subscribed_newsletter",                    :default => true
    t.string   "bank_billet_our_number_6"
    t.string   "bank_billet_link_6"
    t.string   "bank_billet_our_number_12"
    t.string   "bank_billet_link_12"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
