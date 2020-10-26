class CreateClaims < ActiveRecord::Migration[5.2]
  def change
    create_table :claims, :options => 'COLLATE=utf8_general_ci' do |t|
      t.integer :classify
      t.string :claim_content
      t.integer :lot_number
      t.text :claims_image
    end
  end   
end
