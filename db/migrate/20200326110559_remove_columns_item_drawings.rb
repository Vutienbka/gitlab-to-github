class RemoveColumnsItemDrawings < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_drawings, :category_id
  end
end
