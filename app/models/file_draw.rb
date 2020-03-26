class FileDraw < ApplicationRecord
  mount_uploader :file_link, DrawUploader
  belongs_to :draw_category
end
