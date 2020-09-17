class ItemDrawing < ApplicationRecord
  mount_uploaders :file_packing_specifications, DrawUploader
  serialize :file_packing_specifications, JSON # If you use SQLite, add this line.
  mount_uploaders :file_assembly_specifications, DrawUploader
  serialize :file_assembly_specifications, JSON # If you use SQLite, add this line.
  mount_uploaders :file_specifications, DrawUploader
  serialize :file_specifications, JSON # If you use SQLite, add this line.

  after_destroy :remove_file_directory

  belongs_to :item_request

  PARAMS_ATTRIBUTES = [
    :item_request_id, { file_specifications:[] }, { file_assembly_specifications:[] }, { file_packing_specifications:[] }, :creator, :updater
  ]

  def remove_file_directory
    return unless file_packing_specifications.present? ||
                  file_assembly_specifications.present? ||
                  file_specifications.present?

    file_specifications_path = File.expand_path(file_specifications[0].store_path, file_specifications[0].root)
    FileUtils.remove_dir(file_specifications_path, force: false)
    file_assembly_specifications_path = File.expand_path(file_assembly_specifications[0].store_path, file_assembly_specifications[0].root)
    FileUtils.remove_dir(file_assembly_specifications_path, force: false)
    file_packing_specifications_path = File.expand_path(file_packing_specifications[0].store_path, file_packing_specifications[0].root)
    FileUtils.remove_dir(file_packing_specifications_path, force: false)
  end
end
