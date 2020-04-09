class AddColumnsToItemSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :item_samples, :sample_category1_id, :bigint
    add_column :item_samples, :category_type1, :integer, limit: 1
    add_column :item_samples, :sample_category2_id, :bigint
    add_column :item_samples, :category_type2, :integer, limit: 1
    add_column :item_samples, :sample_category3_id, :bigint
    add_column :item_samples, :category_type3, :integer, limit: 1
    add_column :item_samples, :sample_category4_id, :bigint
    add_column :item_samples, :category_type4, :integer, limit: 1

  end
end
