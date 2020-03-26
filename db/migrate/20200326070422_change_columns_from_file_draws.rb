class ChangeColumnsFromFileDraws < ActiveRecord::Migration[5.2]
  def change
    remove_column :file_draws, :item_category
    rename_column :file_draws, :item_draw_id, :draw_category_id
  end
end
