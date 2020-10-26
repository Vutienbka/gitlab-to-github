class AddClaimsIdToItemInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :item_info, :claims_id, :integer
  end
end
