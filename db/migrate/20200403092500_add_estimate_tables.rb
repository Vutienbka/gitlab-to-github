class AddEstimateTables < ActiveRecord::Migration[5.2]
  def change
    create_table "estimation_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "estimation_id", null: false
      t.bigint "item_requests_id", null: false
      t.integer "price"
      t.integer "quantity"
      t.bigint "creator", comment: "登録者Id"
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
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
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
      t.timestamp "deleted_at", comment: "削除時点 Deleted time"
      t.index ["request_id"], name: "fk_estimations_requests1_idx"
    end
  end
end
