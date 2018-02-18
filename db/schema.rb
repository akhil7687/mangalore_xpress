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

ActiveRecord::Schema.define(version: 20180218174641) do

  create_table "enquiries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_name"
    t.string   "user_email"
    t.string   "user_phone"
    t.integer  "service_category_id"
    t.integer  "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["service_category_id"], name: "index_enquiries_on_service_category_id", using: :btree
  end

  create_table "service_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "enable"
    t.string   "icon_img_file_name"
    t.string   "icon_img_content_type"
    t.integer  "icon_img_file_size"
    t.datetime "icon_img_updated_at"
    t.string   "cover_img_file_name"
    t.string   "cover_img_content_type"
    t.integer  "cover_img_file_size"
    t.datetime "cover_img_updated_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "service_provided_desc",  limit: 10000
    t.string   "service_provided",       limit: 5000
    t.string   "slug"
    t.index ["slug"], name: "index_service_categories_on_slug", using: :btree
  end

  add_foreign_key "enquiries", "service_categories"
end
