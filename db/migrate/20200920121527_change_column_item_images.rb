class ChangeColumnItemImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_images, :info
    add_column :item_images, :file_images, :text, after: :item_request_id
  end
end
