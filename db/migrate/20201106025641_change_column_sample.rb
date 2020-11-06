class ChangeColumnSample < ActiveRecord::Migration[5.2]
  def change
    change_column :samples, :category, :text
    change_column :samples, :classify, :text
    change_column :samples, :delivery_request, :text
    change_column :samples, :function, :text
    change_column :samples, :sample_type, :text
  end
end
