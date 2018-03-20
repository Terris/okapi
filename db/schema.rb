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

ActiveRecord::Schema.define(version: 20160629200842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: true do |t|
    t.string   "name"
    t.decimal  "amount_off"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_coupon"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "roster_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["roster_id"], name: "index_enrollments_on_roster_id", using: :btree
  add_index "enrollments", ["student_id"], name: "index_enrollments_on_student_id", using: :btree

  create_table "payments", force: true do |t|
    t.string   "stripe_token"
    t.decimal  "amount",                   precision: 16, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.string   "note"
    t.string   "stripe_charge"
    t.boolean  "stripe_payment_succeeded"
    t.integer  "student_id"
    t.boolean  "receipt_sent"
  end

  add_index "payments", ["student_id"], name: "index_payments_on_student_id", using: :btree
  add_index "payments", ["subscription_id"], name: "index_payments_on_subscription_id", using: :btree

  create_table "plan_coupons", force: true do |t|
    t.integer  "plan_id"
    t.integer  "coupon_id"
    t.date     "tuition_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_coupons", ["coupon_id"], name: "index_plan_coupons_on_coupon_id", using: :btree
  add_index "plan_coupons", ["plan_id"], name: "index_plan_coupons_on_plan_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.decimal  "amount"
    t.string   "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.integer  "interval_count"
  end

  create_table "rosters", force: true do |t|
    t.string   "class_name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "single_charges", force: true do |t|
    t.string   "email"
    t.string   "stripe_token"
    t.decimal  "amount"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_coupons", force: true do |t|
    t.integer  "student_id"
    t.integer  "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "coupon_used"
  end

  add_index "student_coupons", ["coupon_id"], name: "index_student_coupons_on_coupon_id", using: :btree
  add_index "student_coupons", ["student_id"], name: "index_student_coupons_on_student_id", using: :btree

  create_table "students", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invites_sent"
    t.string   "invite_token"
    t.string   "stripe_customer"
    t.boolean  "visible",         default: true
  end

  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_subscription"
    t.string   "invoice_status"
    t.string   "last_four"
    t.integer  "student_id"
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["student_id"], name: "index_subscriptions_on_student_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin"
    t.string   "password_reset_token"
    t.string   "password_reset_sent_at"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deactivated",            default: false
  end

end
