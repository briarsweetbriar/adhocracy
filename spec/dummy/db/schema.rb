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

ActiveRecord::Schema.define(version: 20140306214620) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adhocracy_membership_invitations", force: true do |t|
    t.string   "member_type"
    t.integer  "member_id"
    t.string   "group_type"
    t.integer  "group_id"
    t.boolean  "pending",     default: true,  null: false
    t.boolean  "accepted",    default: false, null: false
    t.boolean  "declined",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adhocracy_membership_invitations", ["member_id", "member_type"], name: "adhocracy_membership_invitations_on_member", using: :btree

  create_table "adhocracy_membership_requests", force: true do |t|
    t.string   "member_type"
    t.integer  "member_id"
    t.string   "group_type"
    t.integer  "group_id"
    t.boolean  "pending",     default: true,  null: false
    t.boolean  "accepted",    default: false, null: false
    t.boolean  "declined",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adhocracy_membership_requests", ["member_id", "member_type"], name: "adhocracy_membership_requests_on_member", using: :btree

  create_table "adhocracy_memberships", force: true do |t|
    t.string   "member_type"
    t.integer  "member_id"
    t.string   "group_type"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adhocracy_memberships", ["group_id", "group_type"], name: "adhocracy_membership_invitations_on_group", using: :btree
  add_index "adhocracy_memberships", ["group_id", "group_type"], name: "adhocracy_membership_requests_on_group", using: :btree
  add_index "adhocracy_memberships", ["group_id", "group_type"], name: "adhocracy_memberships_on_group", using: :btree
  add_index "adhocracy_memberships", ["member_id", "member_type"], name: "adhocracy_memberships_on_member", using: :btree

  create_table "adhocs", force: true do |t|
  end

  create_table "users", force: true do |t|
  end

end
