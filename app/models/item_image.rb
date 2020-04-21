# frozen_string_literal: true

class ItemImage < ApplicationRecord
  acts_as_paranoid
  belongs_to :item_request

  has_many :image_categories
  accepts_nested_attributes_for :image_categories, allow_destroy: true

  PARAMS_ATTRIBUTES = [
    :item_request_id, :info, :creator, :updater,
    image_categories_attributes: [
      :id, :name, :item_drawing_id, :image_info, :creator, :updater,
      file_image_attributes: [:id, :image_category_id, { file_link:[] }]
    ]
  ]
end
