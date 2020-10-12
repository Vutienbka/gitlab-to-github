class AddDeletedAtToCatalog < ActiveRecord::Migration[5.2]
  def change
    add_column :catalogs, :deleted_at, :datetime
  end
end
