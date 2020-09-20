class RemoveImageCategoriesAndFileImages < ActiveRecord::Migration[5.2]
  def change
    drop_table :image_categories
    drop_table :file_images
  end
end
