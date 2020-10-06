class AddCatalogIdToItemRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :item_requests, :catalog_id, :bigint
  end
end
