class AddColumnToItemRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :item_requests, :supplier_id, :bigint, after: :id
    add_column :item_requests, :buyer_supplier_id, :bigint, after: :id
    add_column :item_requests, :buyer_id, :bigint, after: :id
    remove_column :item_requests, :request_id
  end
end
