class RemoveDrawCategoriesAndFileDraws < ActiveRecord::Migration[5.2]
  def change
    drop_table :draw_categories
    drop_table :file_draws
  end
end
