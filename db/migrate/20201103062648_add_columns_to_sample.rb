class AddColumnsToSample < ActiveRecord::Migration[5.2]
  def change
    add_column :samples, :buyer_id, :bigint
    add_column :samples, :sample_type, :string
    add_column :samples, :created_at, :datetime
    add_column :samples, :updated_at, :datetime
    add_column :samples, :deleted_at, :datetime
  end
end
