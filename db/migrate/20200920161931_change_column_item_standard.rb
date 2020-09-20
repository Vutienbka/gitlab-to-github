class ChangeColumnItemStandard < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_standards, :info
    add_column :item_standards, :file_test_criteria, :text, after: :item_request_id
    add_column :item_standards, :file_inspection_criteria, :text, after: :item_request_id
  end
end
