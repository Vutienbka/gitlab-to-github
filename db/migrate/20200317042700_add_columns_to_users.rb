class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :username, :last_name
    add_column :users, :first_name, :string
    add_column :users, :company_name, :string
    add_column :users, :type, :string
    add_column :users, :access_IP, :string
    add_column :users, :deleted_at, :datetime
  end
end
