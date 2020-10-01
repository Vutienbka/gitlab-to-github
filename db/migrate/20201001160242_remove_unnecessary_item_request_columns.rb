class RemoveUnnecessaryItemRequestColumns < ActiveRecord::Migration[5.2]
  def change
    remove_columns :item_requests, :item_info_id, :item_draw_id, :item_image_id, :quality_id, :quality_info, :standard_id, :standard_info, :condition_id, :item_sample_id, :quotation_id
  end
end
