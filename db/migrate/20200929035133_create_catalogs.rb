class CreateCatalogs < ActiveRecord::Migration[5.2]
  def change
    create_table :catalogs do |t|
      t.bigint :parent_catalog_id
      t.string :name
      t.string :level_type

      t.timestamps
    end
  end
end
