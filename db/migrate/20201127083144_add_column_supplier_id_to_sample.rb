class AddColumnSupplierIdToSample < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :supplier_id, :bigint
  end
end
