class ItemDrawing < ApplicationRecord
  belongs_to :item_request
  has_many :draw_categories
  accepts_nested_attributes_for :draw_categories, allow_destroy: true

  PARAMS_ATTRIBUTES = [
    :item_request_id, :info, :creator, :updater,
    draw_categories_attributes: [
      :id, :name, :item_drawing_id, :draw_info, :creator, :updater,
    ]
  ]
end
