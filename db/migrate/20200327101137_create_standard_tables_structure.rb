class CreateStandardTablesStructure < ActiveRecord::Migration[5.2]
  def change
    create_table "file_standard", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ファイルテーブル", force: :cascade do |t|
      t.bigint "standard_category_id", null: false
      t.bigint "item_standard_id", null: false, comment: "Item Draw/Image/Sample Id\n"
      t.string "file_link", null: false, comment: "ファイルリンク"
      t.string "file_name", comment: "ファイルタイプ"
      t.bigint "creator", comment: "登録者Id"
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
      t.timestamp "deleted_at", comment: "削除時点 Deleted time"
      t.index ["standard_category_id"], name: "fk_file_item_standard1_idx"
    end
    create_table "item_standard", primary_key: ["id", "item_request_id"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目基準テーブル", force: :cascade do |t|
      t.bigint "id", null: false, comment: "項目基準Id", auto_increment: true
      t.bigint "item_request_id", null: false
      t.string "info", limit: 2000, comment: "項目基準説明情報"
      t.bigint "creator", comment: "登録者Id"
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
      t.timestamp "deleted_at", comment: "削除時点 Deleted time"
      t.index ["item_request_id"], name: "fk_item_standard_item_requests1_idx"
    end
    create_table "standard_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "項目基準分類テーブル", force: :cascade do |t|
      t.bigint "item_standard_id", null: false
      t.integer "category_id", null: false
      t.string "draw_info", limit: 2000, comment: "項目画面説明情報"
      t.bigint "creator", comment: "登録者Id"
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
      t.timestamp "deleted_at", comment: "削除時点 Deleted time"
      t.index ["item_standard_id"], name: "fk_standard_category_item_standard_idx"
    end
  end
end
