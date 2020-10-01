class AddCatalogIdToItemInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :item_info, :catalog_id, :bigint
  end
end
