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

ActiveRecord::Schema.define(version: 20181003110315) do

  create_table "ads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "ad_img_file_name"
    t.string   "ad_img_content_type"
    t.integer  "ad_img_file_size"
    t.datetime "ad_img_updated_at"
    t.boolean  "enable"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "shown_count",         default: 0
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "classified_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifieds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.text     "description",            limit: 65535
    t.integer  "classified_category_id"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.string   "slug"
    t.integer  "status"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "phone"
    t.index ["classified_category_id"], name: "index_classifieds_on_classified_category_id", using: :btree
    t.index ["slug"], name: "index_classifieds_on_slug", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "user_id"
    t.text     "body",             limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "contest_registrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "contest_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contest_registrations_on_contest_id", using: :btree
  end

  create_table "contests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.boolean  "status"
    t.string   "btn_text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "enquiries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "user_name"
    t.string   "user_email"
    t.string   "user_phone"
    t.integer  "service_category_id"
    t.integer  "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "enquiryable_type"
    t.integer  "enquiryable_id"
    t.index ["enquiryable_type", "enquiryable_id"], name: "index_enquiries_on_enquiryable_type_and_enquiryable_id", using: :btree
    t.index ["service_category_id"], name: "index_enquiries_on_service_category_id", using: :btree
  end

  create_table "feeds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "title",                                                               null: false
    t.binary   "description",      limit: 65535
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.boolean  "status"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.text     "details",          limit: 65535
    t.string   "slug"
    t.boolean  "is_article",                     default: false
    t.string   "news_source"
    t.datetime "published_date",                 default: -> { "CURRENT_TIMESTAMP" }
    t.string   "language",                       default: "English"
    t.string   "category"
    t.string   "image_url"
    t.string   "src_url"
    t.index ["slug"], name: "index_feeds_on_slug", using: :btree
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "market_prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "item_id"
    t.string   "item_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["product_id"], name: "index_product_pictures_on_product_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "price"
    t.integer  "mrp"
    t.integer  "store_id"
    t.boolean  "enable"
    t.string   "product_image_file_name"
    t.string   "product_image_content_type"
    t.integer  "product_image_file_size"
    t.datetime "product_image_updated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["store_id"], name: "index_products_on_store_id", using: :btree
  end

  create_table "real_estate_requirements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "property_type"
    t.string   "property_detail"
    t.string   "budget"
    t.string   "pref_area"
    t.string   "remarks",         limit: 3000
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "service_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
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

  create_table "service_providers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.text     "description",         limit: 65535
    t.string   "speciality"
    t.string   "contact_no"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.integer  "service_category_id"
    t.boolean  "enable"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["service_category_id"], name: "index_service_providers_on_service_category_id", using: :btree
  end

  create_table "stores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.string   "store_logo_file_name"
    t.string   "store_logo_content_type"
    t.integer  "store_logo_file_size"
    t.datetime "store_logo_updated_at"
    t.boolean  "enable"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "user_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "app_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "is_admin",   default: 0
    t.integer  "subscribe",  default: 1
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.string   "name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "app_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "wall_posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "status",                           default: 1
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "description",        limit: 10000
    t.integer  "likes_count"
    t.integer  "comments_count",                   default: 0
    t.index ["user_id"], name: "index_wall_posts_on_user_id", using: :btree
  end

  add_foreign_key "classifieds", "classified_categories"
  add_foreign_key "comments", "users"
  add_foreign_key "contest_registrations", "contests"
  add_foreign_key "enquiries", "service_categories"
  add_foreign_key "likes", "users"
  add_foreign_key "product_pictures", "products"
  add_foreign_key "products", "stores"
  add_foreign_key "service_providers", "service_categories"
  add_foreign_key "wall_posts", "users"
end
