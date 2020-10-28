class AddDeletedAtToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :deleted_at, :datetime
  end
end
