class AddReasonStatusToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :reason_status, :int
  end
end
