class FixColumnNamePattern < ActiveRecord::Migration[5.2]
  def change
    rename_column :patterns, :samples_id, :sample_id
  end
end
