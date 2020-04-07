class AddStatusToItemRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :item_requests, :status, :string
  end
end
