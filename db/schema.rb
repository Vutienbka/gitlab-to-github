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

ActiveRecord::Schema.define(version: 202010230713025) do

  create_table "catalogs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "parent_catalog_id"
    t.string "name"
    t.string "level_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "buyer_id"
    t.datetime "deleted_at"
  end

  create_table "claims", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "classify"
    t.string "claim_content"
    t.integer "lot_number"
    t.text "claims_image"
    t.datetime "created_at"
    t.integer "reason_status"
    t.integer "counter_plan_status"
    t.datetime "deleted_at"
    t.string "claims_cause"
    t.string "claims_solution"
    t.text "claim_cause_images"
    t.text "claim_solution_images"
    t.integer "item_request_id"
    t.integer "supplier_id"
    t.integer "buyer_id"
    t.string "claims_cause"
    t.string "claims_solution"
    t.text "claim_cause_images"
    t.text "claim_solution_images"
  end

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "contract_type", limit: 1
    t.string "contract_status", limit: 45
    t.string "contract_file", limit: 45
    t.date "contract_date"
    t.bigint "profile_id", null: false
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.text "contract_data"
    t.index ["profile_id", "user_id"], name: "fk_buyer_contracts_profile1_idx"
  end

  create_table "estimation_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "estimation_id", null: false
    t.bigint "item_requests_id", null: false
    t.integer "price"
    t.integer "quantity"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["estimation_id"], name: "fk_estimation_detail_estimations1_idx"
    t.index ["item_requests_id"], name: "fk_estimation_detail_item_requests1_idx"
  end

  create_table "estimations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.date "submitted_date"
    t.integer "estimation_status", limit: 1
    t.integer "total_cost"
    t.date "request_by"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["request_id"], name: "fk_estimations_requests1_idx"
  end

  create_table "file_samples", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ファイルテーブル", force: :cascade do |t|
    t.bigint "item_category", null: false
    t.bigint "item_sample_id", null: false, comment: "Item Draw/Image/Sample Id\n"
    t.text "file_link", null: false, comment: "ファイルリンク"
    t.string "file_name", comment: "ファイルタイプ"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_category", "item_sample_id"], name: "fk_file_item_sample_idx"
  end

  create_table "inspection_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "buyer_id"
    t.date "request_date"
    t.integer "request_type", limit: 1
    t.string "inspect_company_name", limit: 45
    t.string "inspect_pic_name", limit: 45
    t.string "inspect_address", limit: 45
    t.string "inspect_tel", limit: 11
    t.integer "inspection_result", limit: 1
    t.string "inspection_result_detail", limit: 45
    t.date "result_issued_date"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_conditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目条件情報", force: :cascade do |t|
    t.bigint "item_request_id"
    t.string "condition", limit: 2000, comment: "項目条件情報"
    t.integer "position", limit: 1
    t.integer "type", limit: 1
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_drawings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目図面テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.text "file_packing_specifications"
    t.text "file_assembly_specifications"
    t.text "file_specifications"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目画面テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.text "file_images"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_info", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目情報テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.string "SKU", limit: 45
    t.string "info_sku", limit: 2000, comment: "項目説明情報"
    t.string "name", limit: 100
    t.string "info_name", limit: 2000
    t.bigint "category1"
    t.bigint "category2"
    t.bigint "category3"
    t.string "info_category", limit: 2000, comment: "項目説明情報"
    t.integer "expected_sales_volume"
    t.string "info_expected_sales_volume", limit: 2000, comment: "項目説明情報"
    t.string "lead_time", limit: 45
    t.string "info_lead_time", limit: 2000
    t.bigint "cost"
    t.text "info_cost"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.string "item_unit"
    t.bigint "catalog_id"
    t.integer "claims_id"
  end

  create_table "item_qualities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目品質テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.integer "quality1", default: 0, comment: "項目品質1"
    t.string "info1", limit: 500, comment: "品質情報1"
    t.integer "quality2", default: 0, comment: "項目品質2"
    t.string "info2", limit: 500, comment: "品質情報2"
    t.integer "quality3", default: 0, comment: "項目品質3"
    t.string "info3", limit: 500, comment: "品質情報3"
    t.integer "quality4", default: 0, comment: "項目品質4"
    t.string "info4", limit: 500, comment: "品質情報4"
    t.integer "quality5", default: 0, comment: "項目品質5"
    t.string "info5", limit: 500, comment: "品質情報5"
    t.integer "quality6", default: 0, comment: "項目品質6"
    t.string "info6", limit: 500, comment: "品質情報6"
    t.integer "quality7", default: 0, comment: "項目品質7"
    t.string "info7", limit: 500, comment: "品質情報7"
    t.integer "quality8", default: 0, comment: "項目品質8"
    t.string "info8", limit: 500, comment: "品質情報8"
    t.integer "quality9", default: 0, comment: "項目品質9"
    t.string "info9", limit: 500, comment: "品質情報9"
    t.integer "quality10", default: 0, comment: "項目品質10"
    t.string "info10", limit: 500, comment: "品質情報10"
    t.integer "quality11", default: 0, comment: "項目品質11"
    t.string "info11", limit: 500, comment: "品質情報11"
    t.integer "quality12", default: 0, comment: "項目品質12"
    t.string "info12", limit: 500, comment: "品質情報12"
    t.integer "quality13", default: 0, comment: "項目品質13"
    t.string "info13", limit: 500, comment: "品質情報13"
    t.integer "quality14", default: 0, comment: "項目品質14"
    t.string "info14", limit: 500, comment: "品質情報14"
    t.integer "quality15", default: 0, comment: "項目品質15"
    t.string "info15", limit: 500, comment: "品質情報15"
    t.integer "quality16", default: 0, comment: "項目品質16"
    t.string "info16", limit: 500, comment: "品質情報16"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "依頼テーブル", force: :cascade do |t|
    t.bigint "buyer_id"
    t.bigint "buyer_supplier_id"
    t.bigint "supplier_id"
    t.string "status"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.bigint "catalog_id"
  end

  create_table "item_standards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目基準テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.text "file_inspection_criteria"
    t.text "file_test_criteria"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "patterns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "pattern"
    t.integer "sample_id"
  end

  create_table "profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "プロバイダー詳細テーブル", force: :cascade do |t|
    t.integer "admin_id"
    t.bigint "buyer_id"
    t.bigint "supplier_id"
    t.bigint "buyer_supplier_id"
    t.string "type", limit: 45
    t.string "first_name", limit: 40, comment: "プロバイダー名"
    t.string "last_name", limit: 40, comment: "プロバイダー別姓"
    t.string "tel", limit: 15, comment: "プロバイダーTEL"
    t.string "company_name", limit: 100, comment: "会社名"
    t.string "code", limit: 45, comment: "会社番号"
    t.string "logo", limit: 45
    t.string "department", limit: 50, comment: "部署名"
    t.string "position", limit: 30, comment: "役職"
    t.bigint "creator", comment: "登録者Id"
    t.string "contract_status", limit: 45, default: "", comment: "NDA契約済み"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "依頼テーブル", force: :cascade do |t|
    t.bigint "buyer_id", null: false, comment: "購入者Id"
    t.bigint "supplier_id", null: false, comment: "供給者Id"
    t.integer "request_status", limit: 1, comment: "登録進捗Id"
    t.date "submitted_date"
    t.date "request_by"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["buyer_id"], name: "fk_request_users1_idx"
  end

  create_table "sample_deliveries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "samples_id"
    t.text "delivery_code"
    t.string "delivery_function"
  end

  create_table "samples", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "category"
    t.text "code"
    t.integer "quantity"
    t.date "delivery_time"
    t.text "classify"
    t.text "delivery_request"
    t.text "function"
    t.bigint "buyer_id"
    t.text "sample_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "updater"
    t.bigint "item_request_id"
    t.bigint "supplier_id"
    t.text "status"
  end

  create_table "user_calendars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目カレンダーテーブル", force: :cascade do |t|
    t.bigint "user_id", comment: "ユーザId"
    t.string "title", limit: 45
    t.string "event_type", limit: 50
    t.string "url"
    t.datetime "occur_date", comment: "イベント日"
    t.string "content", limit: 2000, comment: "イベント内容"
    t.string "occur_time_from", limit: 5
    t.string "occur_time_to", limit: 5
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["user_id"], name: "fk_user_calendar_users1_idx"
  end

  create_table "user_invites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email_invited", limit: 45
    t.integer "notify_status", limit: 1
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["user_id"], name: "fk_buyer_invite_user1_idx"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザテーブル", force: :cascade do |t|
    t.string "email", limit: 100, default: "", null: false, comment: "ログインメールアドレス"
    t.string "encrypted_password", default: "", null: false, comment: "ログインパスワード"
    t.string "type", limit: 45
    t.integer "accept_flg", comment: "利用規約"
    t.integer "antiforce_flg", comment: "反社会勢力"
    t.string "access_IP", limit: 45
    t.string "token"
    t.string "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email", "reset_password_token"], name: "mail_password_reset_token_UNIQUE", unique: true
    t.index ["email"], name: "mail_idx"
  end

end
