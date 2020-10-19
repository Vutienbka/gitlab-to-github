class AddContractDataToContract < ActiveRecord::Migration[5.2]
  def change
    add_column :contracts, :contract_data, :text
  end
end
