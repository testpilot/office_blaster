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

ActiveRecord::Schema.define(:version => 20120211104727) do

  create_table "albums", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "artist_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["artist_id"], :name => "index_albums_on_artist_id"
  add_index "albums", ["name"], :name => "index_albums_on_name"

  create_table "artists", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "libraries", :force => true do |t|
    t.string   "url",         :default => "http://localhost:1337", :null => false
    t.string   "name"
    t.boolean  "online",      :default => false
    t.datetime "imported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", :force => true do |t|
    t.integer  "artist_id",                         :null => false
    t.integer  "album_id"
    t.string   "title"
    t.string   "path"
    t.boolean  "queued",         :default => false
    t.boolean  "now_playing",    :default => false
    t.integer  "playcount",      :default => 0,     :null => false
    t.datetime "last_played_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "songs", ["album_id"], :name => "index_songs_on_album_id"
  add_index "songs", ["artist_id"], :name => "index_songs_on_artist_id"
  add_index "songs", ["title"], :name => "index_songs_on_title"

  create_table "tracks", :force => true do |t|
    t.integer  "library_id",                                 :null => false
    t.integer  "song_id"
    t.integer  "bit_rate",                    :default => 0
    t.string   "kind",          :limit => 16
    t.string   "persistent_id"
    t.integer  "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_handle"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "song_id",                      :null => false
    t.integer  "user_id",                      :null => false
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
