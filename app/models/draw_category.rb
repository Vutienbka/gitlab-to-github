class DrawCategory < ApplicationRecord
  belongs_to :item_drawing
  has_many :file_draws
  accepts_nested_attributes_for :file_draws, allow_destroy: true
end
