class AddUpdaterToSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :updater, :bigint
  end
end
