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

ActiveRecord::Schema[7.1].define(version: 2024_03_15_172742) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "disbursements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_id", null: false
    t.string "reference", null: false
    t.decimal "orders_amount", precision: 16, scale: 2, null: false
    t.decimal "merchant_paid_amount", precision: 16, scale: 2, null: false
    t.decimal "total_fees", precision: 16, scale: 2, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
    t.index ["reference"], name: "index_disbursements_on_reference", unique: true
  end

  create_table "merchant_fees_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_id", null: false
    t.decimal "collected_fees", precision: 16, scale: 2, null: false
    t.decimal "outstanding_fees", precision: 16, scale: 2, null: false
    t.date "date", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["merchant_id", "date"], name: "index_merchant_fees_reports_on_merchant_id_and_date", unique: true
    t.index ["merchant_id"], name: "index_merchant_fees_reports_on_merchant_id"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on"
    t.string "disbursement_frequency", null: false
    t.decimal "minimum_monthly_fee", precision: 16, scale: 2, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_id", null: false
    t.uuid "disbursement_id"
    t.decimal "amount", precision: 16, scale: 2, null: false
    t.decimal "fees", precision: 16, scale: 2
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "external_reference_id"
    t.index ["disbursement_id"], name: "index_orders_on_disbursement_id"
    t.index ["external_reference_id"], name: "index_orders_on_external_reference_id", unique: true
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "merchant_fees_reports", "merchants"
  add_foreign_key "orders", "disbursements"
  add_foreign_key "orders", "merchants"
end
