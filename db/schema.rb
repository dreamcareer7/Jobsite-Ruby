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

ActiveRecord::Schema.define(version: 20210622114420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_cities", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "city_id"
    t.index ["admin_id"], name: "index_admin_cities_on_admin_id", using: :btree
    t.index ["city_id"], name: "index_admin_cities_on_city_id", using: :btree
  end

  create_table "admin_countries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "admin_id"
    t.integer  "country_id"
    t.index ["admin_id"], name: "index_admin_countries_on_admin_id", using: :btree
    t.index ["country_id"], name: "index_admin_countries_on_country_id", using: :btree
  end

  create_table "admin_notifications", force: :cascade do |t|
    t.integer  "notification_type"
    t.text     "content"
    t.string   "page_link"
    t.string   "user_number"
    t.integer  "user_id"
    t.integer  "business_id"
    t.boolean  "resolved",          default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "project_id"
    t.string   "user_email"
    t.string   "user_name"
    t.index ["business_id"], name: "index_admin_notifications_on_business_id", using: :btree
    t.index ["project_id"], name: "index_admin_notifications_on_project_id", using: :btree
    t.index ["user_id"], name: "index_admin_notifications_on_user_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.integer  "role"
    t.boolean  "disabled",               default: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_admins_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "applied_to_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "favoratable_count",       default: 0
    t.index ["owner_type", "owner_id"], name: "index_attachments_on_owner_type_and_owner_id", using: :btree
  end

  create_table "banner_targets", force: :cascade do |t|
    t.integer  "target_listing_id"
    t.string   "target_listing_type"
    t.integer  "target_location_id"
    t.string   "target_location_type"
    t.integer  "banner_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["banner_id"], name: "index_banner_targets_on_banner_id", using: :btree
  end

  create_table "banners", force: :cascade do |t|
    t.string   "title"
    t.string   "banner_type"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "image_en_file_name"
    t.string   "image_en_content_type"
    t.integer  "image_en_file_size"
    t.datetime "image_en_updated_at"
    t.string   "image_ar_file_name"
    t.string   "image_ar_content_type"
    t.integer  "image_ar_file_size"
    t.datetime "image_ar_updated_at"
    t.string   "link_en"
    t.string   "link_ar"
    t.boolean  "enabled",               default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "brand_subsidiaries", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "brand_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["brand_id"], name: "index_brand_subsidiaries_on_brand_id", using: :btree
    t.index ["business_id"], name: "index_brand_subsidiaries_on_business_id", using: :btree
  end

  create_table "brands", force: :cascade do |t|
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_brands_on_business_id", using: :btree
  end

  create_table "business_admins", force: :cascade do |t|
    t.integer  "admin_id"
    t.integer  "business_id"
    t.string   "context"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "business_certifications", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "certification_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "business_contact_translations", force: :cascade do |t|
    t.integer  "business_contact_id", null: false
    t.string   "locale",              null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.index ["business_contact_id"], name: "index_business_contact_translations_on_business_contact_id", using: :btree
    t.index ["locale"], name: "index_business_contact_translations_on_locale", using: :btree
  end

  create_table "business_contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.integer  "business_id"
    t.integer  "position"
    t.index ["business_id"], name: "index_business_contacts_on_business_id", using: :btree
  end

  create_table "business_services", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "service_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "business_translations", force: :cascade do |t|
    t.integer  "business_id",        null: false
    t.string   "locale",             null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "name"
    t.text     "description"
    t.string   "insurance_coverage"
    t.string   "business_hours"
    t.string   "email"
    t.index ["business_id"], name: "index_business_translations_on_business_id", using: :btree
    t.index ["locale"], name: "index_business_translations_on_locale", using: :btree
  end

  create_table "business_verifications", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "verification_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "telephone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.integer  "number_of_employees"
    t.integer  "years_of_establishment"
    t.integer  "number_of_branches"
    t.string   "insurance_coverage"
    t.string   "legal_status"
    t.integer  "user_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.integer  "reviews_count",              default: 0
    t.float    "cached_ranking"
    t.integer  "self_added_projects_count",  default: 0
    t.boolean  "flagged",                    default: false
    t.boolean  "disabled",                   default: false
    t.boolean  "approved",                   default: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "license_number"
    t.integer  "business_type"
    t.integer  "business_class"
    t.integer  "service_area"
    t.integer  "project_size"
    t.integer  "budgets_managed"
    t.string   "slug"
    t.boolean  "residential",                default: false
    t.boolean  "commercial",                 default: false
    t.integer  "min_budget"
    t.integer  "max_budget"
    t.integer  "nb_projects_completed"
    t.boolean  "government"
    t.integer  "admin_editor"
    t.datetime "admin_edit_date"
    t.float    "profile_completion",         default: 0.0
    t.integer  "favoratable_count",          default: 0
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "category_metadata", force: :cascade do |t|
    t.string   "headline"
    t.string   "subheadline"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "category_metadatum_translations", force: :cascade do |t|
    t.integer  "category_metadatum_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "headline"
    t.string   "subheadline"
    t.index ["category_metadatum_id"], name: "index_category_metadatum_translations_on_category_metadatum_id", using: :btree
    t.index ["locale"], name: "index_category_metadatum_translations_on_locale", using: :btree
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.index ["category_id"], name: "index_category_translations_on_category_id", using: :btree
    t.index ["locale"], name: "index_category_translations_on_locale", using: :btree
  end

  create_table "certification_translations", force: :cascade do |t|
    t.integer  "certification_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.index ["certification_id"], name: "index_certification_translations_on_certification_id", using: :btree
    t.index ["locale"], name: "index_certification_translations_on_locale", using: :btree
  end

  create_table "certifications", force: :cascade do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.index ["country_id"], name: "index_certifications_on_country_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.integer  "country_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "slug"
    t.boolean  "disabled",            default: false
  end

  create_table "city_banner_translations", force: :cascade do |t|
    t.integer  "city_banner_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "description"
    t.index ["city_banner_id"], name: "index_city_banner_translations_on_city_banner_id", using: :btree
    t.index ["locale"], name: "index_city_banner_translations_on_locale", using: :btree
  end

  create_table "city_banners", force: :cascade do |t|
    t.integer  "city_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "description"
    t.string   "link"
    t.index ["city_id"], name: "index_city_banners_on_city_id", using: :btree
  end

  create_table "city_translations", force: :cascade do |t|
    t.integer  "city_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["city_id"], name: "index_city_translations_on_city_id", using: :btree
    t.index ["locale"], name: "index_city_translations_on_locale", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "user_one_id"
    t.string  "user_one_type"
    t.integer "user_two_id"
    t.string  "user_two_type"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "continent"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "disabled",   default: false
  end

  create_table "country_translations", force: :cascade do |t|
    t.integer  "country_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "continent"
    t.index ["country_id"], name: "index_country_translations_on_country_id", using: :btree
    t.index ["locale"], name: "index_country_translations_on_locale", using: :btree
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "favoratable_type"
    t.integer  "favoratable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
  end

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "follow_target_type"
    t.integer  "follow_target_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["follow_target_type", "follow_target_id"], name: "index_follows_on_follow_target_type_and_follow_target_id", using: :btree
    t.index ["user_id"], name: "index_follows_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "hidden_resources", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_hidden_resources_on_business_id", using: :btree
    t.index ["project_id"], name: "index_hidden_resources_on_project_id", using: :btree
  end

  create_table "hours_of_operation_translations", force: :cascade do |t|
    t.integer  "hours_of_operation_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "start_day"
    t.string   "end_day"
    t.string   "start_hour"
    t.string   "end_hour"
    t.index ["hours_of_operation_id"], name: "index_hours_of_operation_translations_on_hours_of_operation_id", using: :btree
    t.index ["locale"], name: "index_hours_of_operation_translations_on_locale", using: :btree
  end

  create_table "hours_of_operations", force: :cascade do |t|
    t.string   "start_day"
    t.string   "end_day"
    t.string   "start_hour"
    t.string   "end_hour"
    t.integer  "business_id"
    t.integer  "location_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.time     "start_time"
    t.time     "end_time"
    t.time     "shift_one_start"
    t.time     "shift_one_end"
    t.time     "shift_two_start"
    t.time     "shift_two_end"
    t.integer  "week_period"
    t.index ["business_id"], name: "index_hours_of_operations_on_business_id", using: :btree
    t.index ["location_id"], name: "index_hours_of_operations_on_location_id", using: :btree
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "params"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "location_translations", force: :cascade do |t|
    t.integer  "location_id",    null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "street_address"
    t.string   "location_type"
    t.text     "description"
    t.index ["locale"], name: "index_location_translations_on_locale", using: :btree
    t.index ["location_id"], name: "index_location_translations_on_location_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "city_id"
    t.integer  "zip"
    t.string   "po_box"
    t.string   "street_address"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "number"
    t.text     "description"
    t.string   "location_type"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "sending_user_id"
    t.integer  "receiving_user_id"
    t.string   "sending_user_type"
    t.string   "receiving_user_type"
    t.boolean  "read",                default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "project_id"
    t.integer  "conversation_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "project_id"
    t.integer  "quote_id"
    t.integer  "sending_user_id"
    t.integer  "receiving_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "notification_type"
    t.integer  "business_id"
    t.boolean  "read",                default: false
    t.string   "sending_user_type"
    t.string   "receiving_user_type"
  end

  create_table "photo_galleries", force: :cascade do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_photo_galleries_on_owner_type_and_owner_id", using: :btree
  end

  create_table "project_batches", force: :cascade do |t|
    t.integer  "project1"
    t.integer  "project2"
    t.integer  "project3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_businesses", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "business"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_businesses_on_project_id", using: :btree
  end

  create_table "project_services", force: :cascade do |t|
    t.integer "project_id"
    t.integer "service_id"
    t.integer "quantity"
    t.string  "option"
    t.string  "details"
    t.index ["project_id"], name: "index_project_services_on_project_id", using: :btree
    t.index ["service_id"], name: "index_project_services_on_service_id", using: :btree
  end

  create_table "project_translations", force: :cascade do |t|
    t.integer  "project_id",         null: false
    t.string   "locale",             null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title"
    t.text     "description"
    t.string   "location_type"
    t.string   "project_owner_type"
    t.index ["locale"], name: "index_project_translations_on_locale", using: :btree
    t.index ["project_id"], name: "index_project_translations_on_project_id", using: :btree
  end

  create_table "project_type_joins", force: :cascade do |t|
    t.integer  "project_type_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["project_type_id"], name: "index_project_type_joins_on_project_type_id", using: :btree
  end

  create_table "project_type_translations", force: :cascade do |t|
    t.integer  "project_type_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.index ["locale"], name: "index_project_type_translations_on_locale", using: :btree
    t.index ["project_type_id"], name: "index_project_type_translations_on_project_type_id", using: :btree
  end

  create_table "project_types", force: :cascade do |t|
    t.integer "category_type"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "creation_status"
    t.boolean  "historical_structure"
    t.string   "location_type"
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "project_owner_type"
    t.integer  "category_id"
    t.integer  "business_id"
    t.integer  "project_budget"
    t.integer  "location_class"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_number"
    t.integer  "contact_role"
    t.integer  "timeline_type"
    t.integer  "currency_type"
    t.boolean  "approved",             default: false
    t.string   "reference_number"
    t.integer  "project_status",       default: 0
    t.index ["category_id"], name: "index_projects_on_category_id", using: :btree
  end

  create_table "quote_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "business_id"
    t.string   "status",      default: "pending"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "reference_number"
    t.date     "valid_until"
    t.string   "approximate_duration"
    t.integer  "business_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "project_id"
    t.string   "status",               default: "pending"
    t.text     "introduction"
    t.string   "approximate_budget"
    t.text     "proposal"
  end

  create_table "review_replies", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "review_id"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_review_replies_on_business_id", using: :btree
    t.index ["review_id"], name: "index_review_replies_on_review_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "reliability"
    t.integer  "tidiness"
    t.integer  "courtesy"
    t.integer  "workmanship"
    t.integer  "value_for_money"
    t.text     "comment"
    t.boolean  "recommended"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "business_id"
  end

  create_table "self_added_project_translations", force: :cascade do |t|
    t.integer  "self_added_project_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "title"
    t.text     "description"
    t.index ["locale"], name: "index_self_added_project_translations_on_locale", using: :btree
    t.index ["self_added_project_id"], name: "index_self_added_project_translations_on_self_added_project_id", using: :btree
  end

  create_table "self_added_projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_one_file_name"
    t.string   "image_one_content_type"
    t.integer  "image_one_file_size"
    t.datetime "image_one_updated_at"
    t.string   "image_two_file_name"
    t.string   "image_two_content_type"
    t.integer  "image_two_file_size"
    t.datetime "image_two_updated_at"
    t.string   "image_three_file_name"
    t.string   "image_three_content_type"
    t.integer  "image_three_file_size"
    t.datetime "image_three_updated_at"
    t.string   "video_link"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favoratable_count",        default: 0
  end

  create_table "service_translations", force: :cascade do |t|
    t.integer  "service_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["locale"], name: "index_service_translations_on_locale", using: :btree
    t.index ["service_id"], name: "index_service_translations_on_service_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.integer  "sub_category_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "view_count",        default: 0
    t.integer  "view_count_change", default: 0
    t.string   "slug"
    t.boolean  "hidden",            default: false
    t.boolean  "disabled",          default: false
  end

  create_table "shortlists", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "social_links", force: :cascade do |t|
    t.string  "facebook"
    t.string  "twitter"
    t.string  "linkedin"
    t.string  "owner_type"
    t.integer "owner_id"
    t.string  "youtube"
    t.string  "instagram"
    t.string  "google_plus"
    t.string  "prequalification"
    t.index ["owner_type", "owner_id"], name: "index_social_links_on_owner_type_and_owner_id", using: :btree
  end

  create_table "sponsor_levels", force: :cascade do |t|
    t.string   "level_name"
    t.integer  "listing_targets_count"
    t.integer  "location_targets_count"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sponsors", force: :cascade do |t|
    t.string   "location_owner_type"
    t.integer  "location_owner_id"
    t.string   "listing_owner_type"
    t.integer  "listing_owner_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["listing_owner_type", "listing_owner_id"], name: "index_sponsors_on_listing_owner_type_and_listing_owner_id", using: :btree
    t.index ["location_owner_type", "location_owner_id"], name: "index_sponsors_on_location_owner_type_and_location_owner_id", using: :btree
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "view_count",        default: 0
    t.integer  "view_count_change", default: 0
    t.string   "slug"
    t.boolean  "hidden",            default: false
    t.boolean  "disabled",          default: false
  end

  create_table "sub_category_translations", force: :cascade do |t|
    t.integer  "sub_category_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.index ["locale"], name: "index_sub_category_translations_on_locale", using: :btree
    t.index ["sub_category_id"], name: "index_sub_category_translations_on_sub_category_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "subscription_type"
    t.integer  "user_id"
    t.integer  "business_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "expiry_date"
    t.string   "payment_method"
    t.boolean  "auto_renew",        default: false
    t.string   "reference_number"
    t.string   "amount_paid"
  end

  create_table "team_member_translations", force: :cascade do |t|
    t.integer  "team_member_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.string   "role"
    t.index ["locale"], name: "index_team_member_translations_on_locale", using: :btree
    t.index ["team_member_id"], name: "index_team_member_translations_on_team_member_id", using: :btree
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
    t.integer  "business_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "phone_number"
    t.string   "email"
  end

  create_table "user_callbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.string   "user_number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "age"
    t.date     "birthday"
    t.string   "nationality"
    t.string   "mobile_number"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.integer  "default_profile"
    t.boolean  "disabled",                   default: false
    t.integer  "browse_location"
    t.string   "provider"
    t.string   "uid"
    t.string   "fb_omniauth_info"
    t.string   "google_omniauth_info"
    t.integer  "industry"
    t.string   "linkedin_omniauth_info"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.float    "profile_completion",         default: 0.0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "verification_translations", force: :cascade do |t|
    t.integer  "verification_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.index ["locale"], name: "index_verification_translations_on_locale", using: :btree
    t.index ["verification_id"], name: "index_verification_translations_on_verification_id", using: :btree
  end

  create_table "verifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
