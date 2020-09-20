class RemoveItemSamples < ActiveRecord::Migration[5.2]
  def change
    drop_table :item_samples
  end
end
