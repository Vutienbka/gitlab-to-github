class AddBuyerIdToCatalog < ActiveRecord::Migration[5.2]
  def change
    add_column :catalogs, :buyer_id, :bigint
  end
end
