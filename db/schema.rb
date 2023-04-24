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

ActiveRecord::Schema[7.0].define(version: 2023_04_14_001313) do
  create_table "access_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "callback_urls", force: :cascade do |t|
    t.string "transaction_type"
    t.date "trans_time"
    t.integer "trans_amount"
    t.integer "bill_ref_number"
    t.integer "msisdn"
    t.integer "business_shortcode"
    t.integer "trans_id"
    t.string "resultcode"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_pesas", force: :cascade do |t|
    t.string "checkoutRequestID"
    t.string "merchantRequestID"
    t.string "amount"
    t.string "mpesaReceiptNumber"
    t.string "phoneNumber"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "pnumber"
    t.integer "balance"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
