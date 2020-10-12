class ChangeItemInfoCatalog < ActiveRecord::Migration[5.2]
  def change
    change_column :item_info, :category1, :bigint
    change_column :item_info, :category2, :bigint
    change_column :item_info, :category3, :bigint
  end
end
