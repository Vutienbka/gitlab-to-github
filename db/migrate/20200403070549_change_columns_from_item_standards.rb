class ChangeColumnsFromItemStandards < ActiveRecord::Migration[5.2]
  def change
    add_column :standard_categories, :name, :string, after: :id
    remove_column :standard_categories, :category_id
    remove_column :file_standards, :item_standard_id
    change_column :file_standards, :file_link, :string, null: true
  end
end
