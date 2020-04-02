class RemoveColumnFromItemImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_images, :category_id
    add_column :image_categories, :name, :string, after: :id
    remove_column :file_images, :item_category
    rename_column :file_images, :item_image_id, :image_category_id
    change_column :file_images, :file_link, :string, null: true
  end
end
