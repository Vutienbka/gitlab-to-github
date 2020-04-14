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

ActiveRecord::Schema.define(version: 2020_04_12_141538) do

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "contract_type", limit: 1
    t.string "contract_status", limit: 45
    t.string "contract_file", limit: 45
    t.date "contract_date"
    t.bigint "profile_id", null: false
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["profile_id", "user_id"], name: "fk_buyer_contracts_profile1_idx"
  end

  create_table "draw_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目画面テーブル", force: :cascade do |t|
    t.string "name"
    t.bigint "item_drawing_id", null: false
    t.string "draw_info", limit: 2000, comment: "項目画面説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_drawing_id"], name: "fk_draw_category_item_draw_idx"
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

  create_table "file_draws", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ファイルテーブル", force: :cascade do |t|
    t.bigint "draw_category_id", null: false
    t.text "file_link", comment: "ファイルリンク"
    t.string "file_name", comment: "ファイルタイプ"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["draw_category_id"], name: "fk_file_item_draw1_idx"
  end

  create_table "file_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ファイルテーブル", force: :cascade do |t|
    t.bigint "image_category_id", null: false
    t.text "file_link", comment: "ファイルリンク"
    t.string "file_name", comment: "ファイルタイプ"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["image_category_id"], name: "fk_file_item_image1_idx"
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

  create_table "file_standards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ファイルテーブル", force: :cascade do |t|
    t.bigint "standard_category_id", null: false
    t.text "file_link", comment: "ファイルリンク"
    t.string "file_name", comment: "ファイルタイプ"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["standard_category_id"], name: "fk_file_item_standard1_idx"
  end

  create_table "image_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目画面テーブル", force: :cascade do |t|
    t.string "name"
    t.bigint "item_image_id", null: false
    t.string "image_info", limit: 2000, comment: "項目画面説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_image_id"], name: "fk_image_category_item_image1_idx"
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
    t.string "info", limit: 2000, comment: "項目図面説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目画面テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.string "info", limit: 2000, comment: "項目画面説明情報"
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
    t.string "category1", limit: 1000
    t.string "category2", limit: 1000
    t.string "category3", limit: 1000
    t.string "info_category", limit: 2000, comment: "項目説明情報"
    t.integer "expected_sales_volume"
    t.string "info_expected_sales_volume", limit: 2000, comment: "項目説明情報"
    t.string "lead_time", limit: 45
    t.string "info_lead_time", limit: 2000
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.bigint "cost"
    t.text "info_cost"
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
    t.bigint "item_info_id", comment: "項目情報Id"
    t.bigint "item_draw_id"
    t.bigint "item_image_id"
    t.bigint "quality_id", comment: "項目品質Id"
    t.string "quality_info", limit: 2000, comment: "項目品質説明情報"
    t.bigint "standard_id", comment: "項目基準Id"
    t.string "standard_info", limit: 2000, comment: "項目基準説明情報"
    t.bigint "condition_id", comment: "項目条件Id"
    t.bigint "item_sample_id", comment: "項目金型Id"
    t.bigint "quotation_id", comment: "項目見積Id"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_draw_id"], name: "fk_item_drawing_item_request1_idx"
    t.index ["item_image_id"], name: "fk_item_request_item_image1_idx"
    t.index ["item_info_id"], name: "fk_request_item_info_idx"
    t.index ["item_sample_id"], name: "fk_item_request_item_sample1_idx"
    t.index ["quality_id"], name: "fk_item_quality_item_request1_idx"
  end

  create_table "item_samples", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目サンプルテーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.string "info", limit: 2000, comment: "項目サンプル説明情報"
    t.bigint "sample_category1_id"
    t.integer "category_type1", limit: 1
    t.bigint "sample_category2_id"
    t.integer "category_type2", limit: 1
    t.bigint "sample_category3_id"
    t.integer "category_type3", limit: 1
    t.bigint "sample_category4_id"
    t.integer "category_type4", limit: 1
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
  end

  create_table "item_standards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目基準テーブル", force: :cascade do |t|
    t.bigint "item_request_id"
    t.string "info", limit: 2000, comment: "項目基準説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
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

  create_table "sample_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目画面テーブル", force: :cascade do |t|
    t.bigint "item_sample_id", null: false
    t.string "sample_info", limit: 2000, comment: "項目画面説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_sample_id"], name: "fk_sample_category_item_sample_idx"
  end

  create_table "standard_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目基準分類テーブル", force: :cascade do |t|
    t.string "name"
    t.bigint "item_standard_id", null: false
    t.string "draw_info", limit: 2000, comment: "項目画面説明情報"
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["item_standard_id"], name: "fk_standard_category_item_standard_idx"
  end

  create_table "user_calendars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目カレンダーテーブル", force: :cascade do |t|
    t.bigint "user_id", comment: "ユーザId"
    t.integer "type"
    t.string "title", limit: 45
    t.datetime "occur_date", comment: "イベント日"
    t.string "content", limit: 2000, comment: "イベント内容"
    t.integer "occur_time_from"
    t.string "occur_time_to", limit: 45
    t.bigint "creator", comment: "登録者Id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
    t.bigint "updater", comment: "最終更新者Id"
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
    t.timestamp "deleted_at", comment: "削除時点 Deleted time"
    t.index ["user_id"], name: "fk_user_calendar_users1_idx"
  end

  create_table "user_invites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "user_invited"
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
    t.index ["email", "reset_password_token"], name: "mail_password_reset_token_UNIQUE", unique: true
    t.index ["email"], name: "mail_idx"
  end

end
