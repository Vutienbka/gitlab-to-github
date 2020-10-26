class AddToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :item_request_id, :integer
    add_column :claims, :supplier_id, :integer
    add_column :claims, :buyer_id, :integer
  end
end
