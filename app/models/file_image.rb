class FileImage < ApplicationRecord
  mount_uploaders :file_link, ImageUploader
  serialize :file_link, JSON # If you use SQLite, add this line.

  belongs_to :image_category
end
