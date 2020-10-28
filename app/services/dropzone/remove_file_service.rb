module Dropzone
  class RemoveFileService
    def initialize(index_of, remain_files)
      @index_of = index_of
      @remain_files = remain_files
    end

    def call
      index = @index_of.to_i
      current_files = @remain_files # copy the array
      deleted_file = current_files.delete_at(index) # delete the target image
      deleted_file.try(:remove!) # delete image from S3
      @remain_files = current_files # re-assign back
    end
  end
end
