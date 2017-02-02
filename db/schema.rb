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

ActiveRecord::Schema.define(version: 20141010124423) do

  create_table "addons", force: true do |t|
    t.string   "addon_type"
    t.string   "title"
    t.boolean  "registration_type", default: true
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addons", ["event_id"], name: "index_addons_on_event_id"

  create_table "addresses", force: true do |t|
    t.string   "friendly_name"
    t.string   "street"
    t.string   "street2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "location_type"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "city_address_id"
    t.integer  "city_user_id"
    t.string   "privacy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", force: true do |t|
    t.integer  "addon_id"
    t.string   "title"
    t.float    "price",      default: 0.0
    t.integer  "range_from"
    t.integer  "range_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["addon_id"], name: "index_choices_on_addon_id"

  create_table "city_users", force: true do |t|
    t.integer  "primary_campus_id"
    t.integer  "city_user_id"
    t.string   "first"
    t.string   "last"
    t.string   "gender"
    t.string   "primary_campus_name"
    t.string   "full_name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff",               default: false
    t.string   "email"
  end

  create_table "coupons", force: true do |t|
    t.string   "discount_type"
    t.float    "amount"
    t.string   "coupon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "redeemed"
    t.datetime "expiry_date"
    t.integer  "auto_expire",   default: 1
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "event_option_types", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "organizer"
    t.string   "locale",         default: "en"
    t.string   "timezone"
    t.string   "description"
    t.string   "logo"
    t.string   "reply_to_email"
    t.integer  "guest_count",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step",           default: 0
    t.float    "base_price",     default: 0.0
    t.float    "max_price",      default: 0.0
    t.integer  "seats",          default: 0
    t.boolean  "archive",        default: false
    t.text     "content"
  end

  create_table "family_members", force: true do |t|
    t.integer  "city_user_id"
    t.string   "name"
    t.string   "email"
    t.string   "family_role"
    t.boolean  "active"
    t.string   "full_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "family_members", ["user_id"], name: "index_family_members_on_user_id"

  create_table "payments", force: true do |t|
    t.string   "customer_first_name"
    t.string   "customer_last_name"
    t.string   "customer_address1"
    t.string   "customer_address2"
    t.string   "customer_city"
    t.string   "customer_state"
    t.string   "customer_postal_code"
    t.string   "customer_country"
    t.string   "customer_phone"
    t.string   "customer_email"
    t.integer  "registration_id"
    t.integer  "user_id"
    t.string   "coupon"
    t.float    "order_total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_addons", force: true do |t|
    t.integer  "registration_id"
    t.integer  "addon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "addon_value"
    t.integer  "registration_guest_id"
  end

  add_index "registration_addons", ["registration_guest_id"], name: "index_registration_addons_on_registration_guest_id"
  add_index "registration_addons", ["registration_id"], name: "index_registration_addons_on_registration_id"

  create_table "registration_choices", force: true do |t|
    t.integer  "registration_addon_id"
    t.integer  "choice_id"
    t.integer  "choice_value",          default: 0
    t.float    "choice_price",          default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registration_choices", ["registration_addon_id"], name: "index_registration_choices_on_registration_addon_id"

  create_table "registration_guests", force: true do |t|
    t.integer  "registration_id"
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "primary_phone_type", default: "home"
    t.string   "primary_phone"
    t.string   "guest_type",         default: ""
    t.integer  "city_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.string   "city"
    t.string   "state"
  end

  add_index "registration_guests", ["city_user_id"], name: "index_registration_guests_on_city_user_id"
  add_index "registration_guests", ["registration_id"], name: "index_registration_guests_on_registration_id"

  create_table "registrations", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.float    "amount_payable", default: 0.0
    t.float    "amount_paid",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "amount_total",   default: 0.0
    t.float    "max_price",      default: 0.0
    t.string   "coupon",         default: ""
    t.float    "coupon_amount",  default: 0.0
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id"
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "first"
    t.string   "last"
    t.string   "gender"
    t.string   "user_id"
    t.string   "token"
    t.string   "profile_picture"
    t.string   "global_user_id"
    t.boolean  "staff",           default: false
    t.string   "account_id"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
  end

  create_table "xmldata", force: true do |t|
    t.text     "datafeed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
