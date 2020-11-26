class AddColumnInClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :claim_cause_images, :text
    add_column :claims, :claim_solution_images, :text
  end
end
