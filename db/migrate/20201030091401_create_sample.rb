class CreateSample < ActiveRecord::Migration[5.2]
  def change
    create_table :samples do |t|
      t.string :title
      t.integer :category
      t.text :code
      t.integer :quantity
      t.date :delivery_time
      t.integer :type
      t.integer :delivery_request
      t.integer :function
    end
  end
end
