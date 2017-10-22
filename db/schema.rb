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

ActiveRecord::Schema.define(version: 20171022143905) do

  create_table "deliveries", force: :cascade do |t|
    t.boolean "active", default: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "password"
    t.string "document"
    t.string "imageFacebook"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "license_file_name"
    t.string "license_content_type"
    t.integer "license_file_size"
    t.datetime "license_updated_at"
    t.string "papers_file_name"
    t.string "papers_content_type"
    t.integer "papers_file_size"
    t.datetime "papers_updated_at"
    t.string "longitude", default: "-56.14013671875"
    t.string "latitude", default: "-34.894942447397305"
  end

  create_table "shippings", force: :cascade do |t|
    t.string "latitudeFrom"
    t.string "longitudeFrom"
    t.string "latitudeTo"
    t.string "longitudeTo"
    t.string "emailTo"
    t.decimal "price", precision: 10, scale: 2
    t.integer "status", default: 0
    t.string "postalCodeFrom"
    t.string "postalCodeTo"
    t.integer "delivery_id"
    t.integer "user_id"
    t.string "addressFrom"
    t.string "addressTo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "signature_file_name"
    t.string "signature_content_type"
    t.integer "signature_file_size"
    t.datetime "signature_updated_at"
    t.integer "paymentMedia"
    t.index ["delivery_id"], name: "index_shippings_on_delivery_id"
    t.index ["user_id"], name: "index_shippings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "password"
    t.string "document"
    t.string "imageFacebook"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.boolean "admin", default: false
  end

end
