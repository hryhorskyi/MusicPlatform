# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_31_121643) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name", unique: true
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "initiator_id"
    t.bigint "acceptor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acceptor_id"], name: "index_friends_on_acceptor_id"
    t.index ["initiator_id", "acceptor_id"], name: "index_friends_on_initiator_id_and_acceptor_id", unique: true
    t.index ["initiator_id"], name: "index_friends_on_initiator_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "requestor_id"
    t.bigint "receiver_id"
    t.integer "status", default: 0, null: false
    t.datetime "declined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_invitations_on_receiver_id"
    t.index ["requestor_id"], name: "index_invitations_on_requestor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "friends", "users", column: "acceptor_id"
  add_foreign_key "friends", "users", column: "initiator_id"
  add_foreign_key "invitations", "users", column: "receiver_id"
  add_foreign_key "invitations", "users", column: "requestor_id"
end
