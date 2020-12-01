class AddColumnInSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :status, :text
  end
end
