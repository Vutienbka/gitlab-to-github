class ChangeFileLinkTypeOfFileDraws < ActiveRecord::Migration[5.2]
  def change
    change_column :file_draws, :file_link, :text
    change_column :file_images, :file_link, :text
    change_column :file_samples, :file_link, :text
    change_column :file_standards, :file_link, :text
  end
end
