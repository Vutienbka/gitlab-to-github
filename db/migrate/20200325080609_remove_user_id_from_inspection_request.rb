class RemoveUserIdFromInspectionRequest < ActiveRecord::Migration[5.2]
  def change
    remove_column :inspection_requests, :users_id
  end
end
