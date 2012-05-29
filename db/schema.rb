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

ActiveRecord::Schema.define(:version => 20120529200644) do

  create_table "casefiles", :force => true do |t|
    t.string   "defendant"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ccn"
    t.string   "cr"
    t.string   "cj"
    t.string   "ca"
    t.string   "ct"
    t.string   "sao"
    t.string   "ja"
  end

  create_table "investigations", :force => true do |t|
    t.string   "unit"
    t.integer  "assignee_id"
    t.integer  "assignor"
    t.string   "defendant"
    t.date     "arrest_date"
    t.string   "casenumber"
    t.date     "initial_appearance"
    t.date     "preliminary_hearing"
    t.date     "district_date"
    t.string   "district_room"
    t.string   "victim"
    t.date     "incident_date"
    t.string   "address"
    t.text     "synopsis"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "user_id"
    t.integer  "status"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
    t.date     "event_date"
    t.string   "category"
    t.string   "casenumber"
    t.date     "dob"
    t.string   "adf"
    t.string   "defendant"
    t.integer  "casefile_id"
    t.string   "gang"
    t.integer  "jail",              :limit => 255
    t.string   "probation"
    t.integer  "restitution"
    t.integer  "communityservice"
    t.string   "judge"
    t.string   "leadcharge"
    t.string   "convictedcharges"
    t.boolean  "enhanced"
    t.string   "teamleader"
    t.string   "offendertype"
    t.integer  "guidelines_top"
    t.integer  "guidelines_bottom"
    t.boolean  "aba"
    t.integer  "suspended_time"
    t.integer  "victims"
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "microposts_tags", :id => false, :force => true do |t|
    t.integer "micropost_id"
    t.integer "tag_id"
  end

  create_table "petitions", :force => true do |t|
    t.string   "ccn"
    t.string   "asa"
    t.string   "asa_email"
    t.string   "defendant"
    t.string   "defendant_address"
    t.date     "defendant_dob"
    t.string   "school"
    t.string   "parent"
    t.string   "victim"
    t.string   "victim_address"
    t.boolean  "victim_adult_or_minor"
    t.text     "charges"
    t.string   "cpo_id"
    t.string   "cpo_name"
    t.string   "assisting_officers"
    t.text     "witnesses"
    t.boolean  "chemist"
    t.boolean  "pwid"
    t.boolean  "fingerprint"
    t.boolean  "examiner"
    t.boolean  "tech"
    t.boolean  "counterfeit"
    t.string   "expert_content"
    t.string   "corespondents"
    t.boolean  "incident_report"
    t.boolean  "statement_of_respondent"
    t.boolean  "statement_of_corespondents_etc"
    t.boolean  "victim_witness_list"
    t.boolean  "arrest_report"
    t.boolean  "investigation_report"
    t.boolean  "accident_report"
    t.boolean  "screening_apt"
    t.text     "statement_of_pc"
    t.string   "incident_address"
    t.string   "mitigation"
    t.string   "search_and_seizures"
    t.integer  "respondent_statement_type"
    t.string   "respondent_statement"
    t.integer  "witness_statement_type"
    t.string   "witness_statement"
    t.string   "premerits_id"
    t.boolean  "medical_records"
    t.boolean  "business_records"
    t.boolean  "police_records"
    t.boolean  "mva_records"
    t.boolean  "other_records"
    t.string   "other_description"
    t.date     "offense_date"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "agency"
    t.string   "email_address"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todoitems", :force => true do |t|
    t.string   "content"
    t.date     "duedate"
    t.integer  "priority"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "complete"
    t.string   "casenumber"
    t.integer  "user_id"
  end

  add_index "todoitems", ["created_at"], :name => "index_todoitems_on_todolist_id_and_created_at"

  create_table "todolists", :force => true do |t|
    t.string   "name"
    t.integer  "casefile_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "todolists", ["casefile_id", "created_at"], :name => "index_todolists_on_casefile_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "title"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
