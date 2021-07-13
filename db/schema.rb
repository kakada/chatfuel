# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_13_061812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content_type"
    t.integer "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.string "platform_name", default: ""
    t.datetime "last_interaction_at", default: -> { "CURRENT_TIMESTAMP" }
    t.string "province_id"
    t.string "district_id", limit: 8
    t.string "gender", default: ""
    t.boolean "repeated", default: false
    t.index ["content_type", "content_id"], name: "index_messages_on_content_type_and_content_id"
  end

  create_table "pdf_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "content", default: ""
    t.string "lang_code", default: "en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "quota", force: :cascade do |t|
    t.string "platform_name", default: "messenger"
    t.integer "threshold", default: 0
    t.float "secure_zone", default: 0.75
    t.integer "total_sent", default: 0
    t.string "on_reach_threshold", default: "delay"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "role_variables", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "variable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_role_variables_on_role_id"
    t.index ["variable_id"], name: "index_role_variables_on_variable_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "name", null: false
    t.string "cron", null: false
    t.boolean "enabled", default: false
    t.string "worker", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.string "session_type", default: ""
    t.string "platform_name", default: ""
    t.integer "status", default: 0
    t.string "district_id"
    t.string "province_id"
    t.datetime "last_interaction_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "gender", default: ""
    t.boolean "repeated", default: false
    t.string "source_id", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "var", null: false
    t.text "value"
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "site_settings", force: :cascade do |t|
    t.text "message_template"
    t.text "digest_message_template"
    t.integer "message_frequency"
    t.boolean "enable_notification", default: false
    t.bigint "site_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.index ["site_id"], name: "index_site_settings_on_site_id"
  end

  create_table "site_settings_telegram_chat_groups", id: :serial, force: :cascade do |t|
    t.bigint "site_setting_id", null: false
    t.bigint "telegram_chat_group_id", null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "code", default: ""
    t.integer "tracks_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.integer "sync_status"
    t.string "token", default: ""
    t.text "whitelist"
    t.float "lat"
    t.float "lng"
    t.string "province_id"
    t.datetime "deleted_at"
    t.string "name_km"
    t.index ["deleted_at"], name: "index_sites_on_deleted_at"
    t.index ["name_en"], name: "index_sites_on_name_en"
  end

  create_table "social_providers", force: :cascade do |t|
    t.string "provider_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "step_values", force: :cascade do |t|
    t.bigint "variable_value_id", null: false
    t.bigint "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "message_id"
    t.bigint "variable_id", null: false
    t.bigint "session_id"
    t.index ["message_id"], name: "index_step_values_on_message_id"
    t.index ["session_id"], name: "index_step_values_on_session_id"
    t.index ["site_id"], name: "index_step_values_on_site_id"
    t.index ["variable_id"], name: "index_step_values_on_variable_id"
    t.index ["variable_value_id"], name: "index_step_values_on_variable_value_id"
  end

  create_table "sync_history_logs", force: :cascade do |t|
    t.string "uuid", default: "", null: false
    t.hstore "payload", default: {}, null: false
    t.integer "success_count", default: 0
    t.integer "failure_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "site_id"
    t.index ["uuid"], name: "index_sync_history_logs_on_uuid"
  end

  create_table "sync_logs", force: :cascade do |t|
    t.integer "site_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "telegram_bots", force: :cascade do |t|
    t.string "username"
    t.string "token"
    t.boolean "actived", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "telegram_chat_groups", force: :cascade do |t|
    t.string "title"
    t.integer "chat_id"
    t.boolean "is_active"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "content", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "0"
    t.string "type", null: false
  end

  create_table "text_messages", force: :cascade do |t|
    t.string "messenger_user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "profile_pic_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "code", null: false
    t.string "status"
    t.date "completed_at"
    t.date "actual_completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "incomplete_at"
    t.date "incorrect_at"
    t.bigint "site_id", null: false
    t.string "tel"
    t.string "service_description"
    t.string "dist_gis"
    t.datetime "requested_date"
    t.datetime "approved_date"
    t.datetime "delivery_date"
    t.string "sector", default: ""
    t.index ["code"], name: "index_tickets_on_code"
    t.index ["site_id"], name: "index_tickets_on_site_id"
  end

  create_table "trackings", force: :cascade do |t|
    t.integer "status"
    t.string "ticket_code"
    t.string "site_code"
    t.datetime "tracking_datetime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "session_id"
    t.index ["session_id"], name: "index_trackings_on_session_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "code"
    t.bigint "site_id"
    t.bigint "step_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ticket_id"
    t.index ["site_id"], name: "index_tracks_on_site_id"
    t.index ["step_id"], name: "index_tracks_on_step_id"
    t.index ["ticket_id"], name: "index_tracks_on_ticket_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "mid"
    t.string "first_name"
    t.string "gender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "status", default: 0
    t.bigint "site_id"
    t.integer "role_id"
    t.string "avatar"
    t.boolean "actived"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["site_id"], name: "index_users_on_site_id"
  end

  create_table "variable_values", force: :cascade do |t|
    t.string "raw_value", null: false
    t.string "mapping_value_en", default: ""
    t.string "status", default: "1"
    t.bigint "variable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "step_values_count", default: 0
    t.string "hint", limit: 255, default: ""
    t.string "mapping_value_km", default: ""
    t.boolean "is_criteria", default: false
    t.string "type_of", default: ""
    t.index ["variable_id"], name: "index_variable_values_on_variable_id"
  end

  create_table "variables", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "report_enabled", default: false
    t.boolean "is_most_request", default: false
    t.boolean "is_user_visit", default: false
    t.boolean "is_location"
    t.boolean "is_ticket_tracking", default: false
    t.boolean "is_service_accessed", default: false
    t.string "mark_as", default: ""
    t.index ["mark_as"], name: "index_variables_on_mark_as"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "voice_messages", force: :cascade do |t|
    t.integer "callsid"
    t.string "address"
    t.datetime "called_at"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "project_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "identities", "users"
  add_foreign_key "role_variables", "roles"
  add_foreign_key "role_variables", "variables"
  add_foreign_key "site_settings", "sites"
  add_foreign_key "step_values", "messages"
  add_foreign_key "step_values", "sessions"
  add_foreign_key "step_values", "sites"
  add_foreign_key "step_values", "variable_values"
  add_foreign_key "step_values", "variables"
  add_foreign_key "tickets", "sites"
  add_foreign_key "trackings", "sessions"
  add_foreign_key "users", "roles"
  add_foreign_key "variable_values", "variables"
end
