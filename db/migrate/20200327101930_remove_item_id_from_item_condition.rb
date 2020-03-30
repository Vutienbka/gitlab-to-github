class RemoveItemIdFromItemCondition < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_conditions, :item_id
  end
end
