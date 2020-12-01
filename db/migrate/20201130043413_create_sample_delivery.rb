class CreateSampleDelivery < ActiveRecord::Migration[5.2]
  def change
    create_table :sample_deliveries do |t|
      t.bigint :samples_id
      t.text :delivery_code
      t.string :delivery_function
    end
  end
end
