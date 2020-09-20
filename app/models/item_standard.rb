# frozen_string_literal: true

class ItemStandard < ApplicationRecord
  mount_uploaders :file_inspection_criteria, DrawUploader
  serialize :file_inspection_criteria, JSON # If you use SQLite, add this line.
  mount_uploaders :file_test_criteria, DrawUploader
  serialize :file_test_criteria, JSON # If you use SQLite, add this line.

  belongs_to :item_request

  PARAMS_ATTRIBUTES = [
    :item_request_id, :info, :creator, :updater,
    { file_inspection_criteria: [] }, { file_test_criteria: [] }
  ].freeze
end
