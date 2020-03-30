class ItemRequest < ApplicationRecord
  acts_as_paranoid

  belongs_to :request
  has_one :item_info, dependent: :destroy
  has_one :item_quanlity, dependent: :destroy
  has_one :item_drawing, dependent: :destroy
  has_one :item_sample, dependent: :destroy
  has_one :item_image, dependent: :destroy
  has_many :item_conditions, dependent: :destroy

  accepts_nested_attributes_for :item_conditions, allow_destroy: true

  PARAMS_ATTRIBUTES = [
    item_conditions_attributes: [
      :id, :item_request_id, :condition, :position
    ]
  ]
end
