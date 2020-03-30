class AddColumnToTableConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :item_conditions, :item_request_id, :bigint, after: :id
  end
end
