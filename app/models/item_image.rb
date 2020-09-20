# frozen_string_literal: true

class ItemImage < ApplicationRecord
  mount_uploaders :file_images, ImageUploader
  serialize :file_images, JSON # If you use SQLite, add this line.

  belongs_to :item_request

  PARAMS_ATTRIBUTES = [
    :item_request_id, :info, :creator, :updater,
    { file_images: [] }
  ].freeze
end
