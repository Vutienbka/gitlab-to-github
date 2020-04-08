class ChangeRequestStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :requests, :request_status, :tinyint, null: true
  end
end
