class AddClaimsCauseToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :claims_cause, :string
    add_column :claims, :claims_solution, :string
  end
end
