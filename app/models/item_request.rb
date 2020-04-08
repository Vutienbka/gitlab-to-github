class ItemRequest < ApplicationRecord
  acts_as_paranoid
  extend Enumerize

  belongs_to :request
  has_one :item_info, dependent: :destroy
  has_one :item_quality, dependent: :destroy
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

  STATUSES = {
    'information': 1,
    'draw': 2,
    'image': 3,
    'quality': 4,
    'standard': 5,
    'condition': 6,
    'sample': 7,
    'estimate': 8,
    'low_cost': 9
  }

  enumerize :status, in: STATUSES, predicates: { prefix: true }
end
