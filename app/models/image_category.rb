class ImageCategory < ApplicationRecord
  belongs_to :item_image
  has_one :file_image
  accepts_nested_attributes_for :file_image, allow_destroy: true, update_only: true

  TYPES = [ 'TYPE1', 'TYPE2']
end
