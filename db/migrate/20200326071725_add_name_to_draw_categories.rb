class AddNameToDrawCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :draw_categories, :name, :string, after: :id
  end
end
