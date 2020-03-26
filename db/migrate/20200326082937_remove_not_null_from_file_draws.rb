class RemoveNotNullFromFileDraws < ActiveRecord::Migration[5.2]
  def change
    change_column :file_draws, :file_link, :string, null: true
  end
end
