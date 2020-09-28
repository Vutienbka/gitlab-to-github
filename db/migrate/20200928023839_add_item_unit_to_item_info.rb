class AddItemUnitToItemInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :item_info, :item_unit, :string
  end
end
