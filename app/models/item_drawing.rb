# frozen_string_literal: true

class ItemDrawing < ApplicationRecord
  mount_uploaders :file_packing_specifications, DrawUploader
  serialize :file_packing_specifications, JSON # If you use SQLite, add this line.
  mount_uploaders :file_assembly_specifications, DrawUploader
  serialize :file_assembly_specifications, JSON # If you use SQLite, add this line.
  mount_uploaders :file_specifications, DrawUploader
  serialize :file_specifications, JSON # If you use SQLite, add this line.

  belongs_to :item_request

  PARAMS_ATTRIBUTES = [
    :item_request_id, { file_specifications: [] }, { file_assembly_specifications: [] }, { file_packing_specifications: [] }, :creator, :updater
  ].freeze
end
