class RemoveColumnOfUserInvites < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_invites, :user_invited
  end
end
