class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.bigint :buyer_id
      t.bigint :supplier_id
      t.bigint :buyer_supplier_id
      t.string :contract_status
      t.string :type
      t.datetime :deleted_at
    end
  end
end
