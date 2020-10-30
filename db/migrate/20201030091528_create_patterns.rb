class CreatePatterns < ActiveRecord::Migration[5.2]
  def change
    create_table :patterns do |t|
      t.text :pattern
      t.integer :samples_id
    end
  end
end
