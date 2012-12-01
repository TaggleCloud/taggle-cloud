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

ActiveRecord::Schema.define(:version => 20121201035135) do

  create_table "abstract_tags", :force => true do |t|
    t.integer  "abstract_id"
    t.integer  "tag_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "abstracts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "attendance_id"
    t.text     "body"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "is_bio",        :default => false
  end

  create_table "attendances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "conference_id"
    t.string   "registered_email"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization"
    t.string   "project_name"
  end

  create_table "authentication", :force => true do |t|
    t.integer  "authentication_id"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "authentication_id"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "conferences", :force => true do |t|
    t.string   "location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "connections", :force => true do |t|
    t.integer  "attendance1_id"
    t.integer  "attendance2_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "strength"
  end

  create_table "coordinates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "conference_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "mail_address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "interests", :force => true do |t|
    t.string   "interest"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "attendance_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "conference_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "interest_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image"
    t.string   "location"
    t.string   "occupation"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin"
    t.boolean  "show_email"
  end

end
