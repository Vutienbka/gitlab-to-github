class ChangeClassifyToBeTextInClaim < ActiveRecord::Migration[5.2]
  def change
    change_column:claims, :classify, :text
  end
end
