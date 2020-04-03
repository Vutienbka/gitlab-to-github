class ChangeColumnFromItemStandard < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_standards, :item_request_id
  end
end
