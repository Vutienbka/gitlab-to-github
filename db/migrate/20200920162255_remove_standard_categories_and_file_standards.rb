class RemoveStandardCategoriesAndFileStandards < ActiveRecord::Migration[5.2]
  def change
    drop_table :standard_categories
    drop_table :file_standards
  end
end
