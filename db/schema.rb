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

ActiveRecord::Schema.define(:version => 20130816151119) do

  create_table "configuration_files", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "configuration_files", ["name"], :name => "index_configuration_files_on_name", :unique => true
  add_index "configuration_files", ["slug"], :name => "index_configuration_files_on_slug"

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "configuration_file_id"
  end

  add_index "parameters", ["value"], :name => "index_parameters_on_value"

end
