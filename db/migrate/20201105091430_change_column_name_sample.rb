class ChangeColumnNameSample < ActiveRecord::Migration[5.2]
  def change
    rename_column :samples, :type, :classify
  end
end
