class ChangeColumnsToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :admin_id, :integer

    change_column :user_invites, :user_invited, :integer
  end
end
