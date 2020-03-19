class AddColumnsToItemInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :item_info, :cost, :bigint
    add_column :item_info, :info_cost, :text
  end
end
