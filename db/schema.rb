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

ActiveRecord::Schema.define(version: 20140813165204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_activities", force: true do |t|
    t.string   "card_id"
    t.string   "list_id"
    t.date     "entry_date"
    t.date     "exit_date"
    t.integer  "time_in_list"
    t.integer  "grouping_year"
    t.integer  "grouping_month"
    t.integer  "grouping_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "board_id"
  end

  add_index "card_activities", ["card_id"], name: "index_card_activities_on_card_id", using: :btree
  add_index "card_activities", ["grouping_year", "grouping_month"], name: "index_card_activities_on_grouping_year_and_grouping_month", using: :btree
  add_index "card_activities", ["grouping_year", "grouping_week"], name: "index_card_activities_on_grouping_year_and_grouping_week", using: :btree
  add_index "card_activities", ["list_id"], name: "index_card_activities_on_list_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "model_id"
    t.string   "description"
    t.string   "callback_url"
    t.string   "webhook_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["model_id"], name: "index_subscriptions_on_model_id", using: :btree

end
