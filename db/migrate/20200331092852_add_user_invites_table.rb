class AddUserInvitesTable < ActiveRecord::Migration[5.2]
  def change
    create_table "user_invites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.integer "user_invited", limit: 1
      t.string "email_invited", limit: 45
      t.integer "notify_status", limit: 1
      t.bigint "creator", comment: "登録者Id"
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "登録日"
      t.bigint "updater", comment: "最終更新者Id"
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "最終更新日"
      t.timestamp "deleted_at", comment: "削除時点 Deleted time"
      t.index ["user_id"], name: "fk_buyer_invite_user1_idx"
    end
  end
end
