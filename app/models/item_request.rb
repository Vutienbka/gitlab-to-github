class ItemRequest < ApplicationRecord
  acts_as_paranoid

  belongs_to :request
  has_one :item_info, dependent: :destroy
  has_one :item_quanlity, dependent: :destroy
  has_one :item_drawing, dependent: :destroy
  has_one :item_sample, dependent: :destroy
  has_one :item_image, dependent: :destroy
end
