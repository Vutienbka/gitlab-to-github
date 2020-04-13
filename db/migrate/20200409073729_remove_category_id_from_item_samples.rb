class RemoveCategoryIdFromItemSamples < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_samples, :category_id, :bigint
  end
end
