class ChangeColumnItemDrawings < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_drawings, :info
    add_column :item_drawings, :file_specifications, :text, after: :item_request_id
    add_column :item_drawings, :file_assembly_specifications, :text, after: :item_request_id
    add_column :item_drawings, :file_packing_specifications, :text, after: :item_request_id
  end
end
