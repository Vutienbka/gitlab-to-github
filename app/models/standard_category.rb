class StandardCategory < ApplicationRecord
  belongs_to :item_standard
  has_one :file_standard
  accepts_nested_attributes_for :file_standard, allow_destroy: true, update_only: true

  TYPES = [ 'STANDARD_TYPE1', 'STANDARD_TYPE2']
end
