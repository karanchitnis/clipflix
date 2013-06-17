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

ActiveRecord::Schema.define(:version => 20130614233723) do

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "cur_play",           :default => false
    t.string   "privacy",            :default => "Public"
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_score", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
  end

  add_index "playlists", ["cached_votes_down"], :name => "index_playlists_on_cached_votes_down"
  add_index "playlists", ["cached_votes_score"], :name => "index_playlists_on_cached_votes_score"
  add_index "playlists", ["cached_votes_total"], :name => "index_playlists_on_cached_votes_total"
  add_index "playlists", ["cached_votes_up"], :name => "index_playlists_on_cached_votes_up"
  add_index "playlists", ["user_id", "created_at"], :name => "index_playlists_on_user_id_and_created_at"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "searches", :force => true do |t|
    t.string   "last_title"
    t.string   "last_normurl"
    t.string   "last_url"
    t.string   "last_thumburl"
    t.string   "last_width"
    t.string   "last_height"
    t.string   "last_provider"
    t.text     "last_embed"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "static_pages", :force => true do |t|
    t.string   "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",            :default => false
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "last_click_url"
    t.string   "last_title"
    t.string   "last_url"
    t.string   "last_thumburl"
    t.string   "last_width"
    t.string   "last_height"
    t.string   "last_provider"
    t.text     "last_embed"
    t.string   "last_normurl"
    t.integer  "num_vids",         :default => 0
    t.string   "last_psearch"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "thumbnail"
    t.string   "provider"
    t.text     "embed"
    t.integer  "position"
    t.integer  "playlist_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "cur_vid",     :default => false
    t.integer  "user_id"
    t.string   "norm_url"
  end

  add_index "videos", ["playlist_id", "created_at"], :name => "index_videos_on_playlist_id_and_created_at"
  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
