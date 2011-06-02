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

ActiveRecord::Schema.define(:version => 20110512005435) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_type"], :name => "index_categories_on_category_type"

  create_table "categories_posts", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "category_id"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "active"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.integer  "city_id"
    t.string   "membership_type"
  end

  create_table "community_images", :force => true do |t|
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "post_community_relationships", :force => true do |t|
    t.integer  "post_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_community_relationships", ["community_id"], :name => "index_post_community_relationships_on_community_id"
  add_index "post_community_relationships", ["post_id", "community_id"], :name => "index_post_community_relationships_on_post_id_and_community_id", :unique => true
  add_index "post_community_relationships", ["post_id"], :name => "index_post_community_relationships_on_post_id"

  create_table "post_images", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "trade_for"
    t.integer  "city_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",          :default => false
    t.string   "email"
    t.string   "activation_hash"
    t.datetime "activated_at"
  end

  add_index "posts", ["city_id"], :name => "index_posts_on_city_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trade_messages", :force => true do |t|
    t.integer  "trade_id"
    t.string   "message"
    t.boolean  "from_trader"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trade_messages", ["trade_id"], :name => "index_trade_messages_on_trade_id"

  create_table "trades", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.string   "email"
    t.boolean  "poster_read_flag"
    t.boolean  "trader_read_flag"
    t.boolean  "active",           :default => false
    t.string   "activation_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content"
    t.datetime "activated_at"
  end

  add_index "trades", ["post_id"], :name => "index_trades_on_post_id"
  add_index "trades", ["user_id"], :name => "index_trades_on_user_id"

  create_table "user_community_relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_community_relationships", ["community_id"], :name => "index_user_community_relationships_on_community_id"
  add_index "user_community_relationships", ["user_id", "community_id"], :name => "index_user_community_relationships_on_user_id_and_community_id", :unique => true
  add_index "user_community_relationships", ["user_id"], :name => "index_user_community_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "active",             :default => false
    t.string   "activation_hash"
    t.datetime "activated_at"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
