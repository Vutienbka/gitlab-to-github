class AddItemRequestIdToSample < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :item_request_id, :bigint
  end
end
