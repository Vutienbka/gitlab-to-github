class AddAutoincrementToTables < ActiveRecord::Migration[5.2]
  def change
    change_column :inspection_requests, :id, :integer, limit: 8, auto_increment: true
    change_column :item_info, :id, :integer, limit: 8, auto_increment: true
    change_column :item_drawings, :id, :integer, limit: 8, auto_increment: true
    change_column :item_qualities, :id, :integer, limit: 8, auto_increment: true
    change_column :item_images, :id, :integer, limit: 8, auto_increment: true
    change_column :item_samples, :id, :integer, limit: 8, auto_increment: true
    change_column :item_conditions, :id, :integer, limit: 8, auto_increment: true
    change_column :contracts, :id, :integer, limit: 8, auto_increment: true
    change_column :user_calendars, :id, :integer, limit: 8, auto_increment: true
    change_column :image_categories, :id, :integer, limit: 8, auto_increment: true
    change_column :draw_categories, :id, :integer, limit: 8, auto_increment: true
    change_column :sample_categories, :id, :integer, limit: 8, auto_increment: true
  end
end
