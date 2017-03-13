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

ActiveRecord::Schema.define(version: 20170313035943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "version"
    t.string   "streetname"
    t.string   "num"
    t.float    "lat"
    t.float    "lng"
    t.integer  "lo"
    t.integer  "hi"
    t.string   "losuf"
    t.string   "hisuf"
    t.string   "locname"
    t.string   "mun"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["streetname", "num"], name: "index_addresses_on_streetname_and_num", using: :btree
  end

  create_table "archives", force: :cascade do |t|
    t.string   "filename"
    t.boolean  "is_geo"
    t.boolean  "processed"
    t.datetime "startprocessing"
    t.datetime "endprocessing"
    t.integer  "count"
    t.integer  "version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["filename"], name: "index_archives_on_filename", unique: true, using: :btree
  end

  create_table "inspections", force: :cascade do |t|
    t.integer  "rid"
    t.integer  "eid"
    t.integer  "iid"
    t.string   "etype"
    t.string   "status"
    t.string   "details"
    t.string   "date"
    t.string   "severity"
    t.string   "action"
    t.string   "outcome"
    t.integer  "mipy"
    t.integer  "version"
    t.integer  "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eid"], name: "index_inspections_on_eid", using: :btree
  end

  create_table "multiples", force: :cascade do |t|
    t.integer  "timestamp"
    t.integer  "iid"
    t.string   "streetname"
    t.integer  "eid"
    t.string   "num"
    t.integer  "lo"
    t.integer  "hi"
    t.string   "losuf"
    t.string   "hisuf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notfounds", force: :cascade do |t|
    t.integer  "timestamp"
    t.boolean  "found"
    t.string   "streetname"
    t.integer  "iid"
    t.integer  "eid"
    t.string   "num"
    t.integer  "lo"
    t.integer  "hi"
    t.string   "losuf"
    t.string   "hisuf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.integer  "address_id"
    t.string   "venuename"
    t.integer  "eid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eid"], name: "index_venues_on_eid", unique: true, using: :btree
  end

end
