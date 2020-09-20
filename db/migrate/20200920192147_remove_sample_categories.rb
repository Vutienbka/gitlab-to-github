class RemoveSampleCategories < ActiveRecord::Migration[5.2]
  def change
    drop_table :sample_categories do |t|
      t.bigint :item_sample_id
      t.string :sample_info
      t.bigint :creator
      t.bigint :updater
      t.date :deleted_at
      t.timestamps null: false
    end
  end
end
