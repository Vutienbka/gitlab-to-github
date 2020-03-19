class AddColumnsToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :item_info, :item_request_id, :bigint, after: :id
    add_column :item_qualities, :item_request_id, :bigint, after: :id
    add_column :item_drawings, :item_request_id, :bigint, after: :id
    add_column :item_samples, :item_request_id, :bigint, after: :id
    add_column :item_images, :item_request_id, :bigint, after: :id
  end
end
