class RenameColumnDrawCategory < ActiveRecord::Migration[5.2]
  def change
    rename_column :draw_categories, :item_draw_id, :item_drawing_id
  end
end
