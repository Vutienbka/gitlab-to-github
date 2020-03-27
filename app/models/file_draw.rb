class FileDraw < ApplicationRecord
  mount_uploaders :file_link, DrawUploader
  serialize :file_link, JSON # If you use SQLite, add this line.

  belongs_to :draw_category
end
