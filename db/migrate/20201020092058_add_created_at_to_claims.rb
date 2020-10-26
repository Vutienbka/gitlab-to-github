class AddCreatedAtToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :created_at, :datetime
  end
end
