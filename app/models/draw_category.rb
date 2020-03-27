class DrawCategory < ApplicationRecord
  belongs_to :item_drawing
  has_one :file_draw
  accepts_nested_attributes_for :file_draw, allow_destroy: true, update_only: true

  TYPES = [
    '製品仕様図（2D）', '組立仕様図（2D）', '梱包仕様図（2D）',
    '製品仕様図（3D）', '組立仕様図（3D）', '梱包仕様図（3D）'
  ]
end
