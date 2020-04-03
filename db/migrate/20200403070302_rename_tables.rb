class RenameTables < ActiveRecord::Migration[5.2]
  def change
    rename_table :item_standard, :item_standards
    rename_table :file_standard, :file_standards
  end
end
