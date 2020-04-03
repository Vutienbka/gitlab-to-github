# frozen_string_literal: true

class ItemStandard < ApplicationRecord
  belongs_to :item_request

  has_many :standard_categories
  accepts_nested_attributes_for :standard_categories, allow_destroy: true

  PARAMS_ATTRIBUTES = [
    :item_request_id, :info, :creator, :updater,
    standard_categories_attributes: [
      :id, :name, :item_standard_id, :draw_info, :creator, :updater,
      file_standards_attributes: [:id, :standard_category_id, { file_link:[] }]
    ]
  ]
end
