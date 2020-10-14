require 'open-uri'
require 'zip/zip'

module ItemServices
  class DownloadService
    def initialize(item_request, field_name, file_name_version, file_paths)
      @item_request = item_request
      @field_name = field_name
      @file_name_version = file_name_version
      @file_paths = file_paths
    end

    def call
      case @field_name
      when 'file_specifications'
        @item_drawings_path = @item_request.item_drawing.file_specifications.map { |drawing| drawing.url }
      when 'file_assembly_specifications'
        @item_drawings_path = @item_request.item_drawing.file_assembly_specifications.map { |drawing| drawing.url }
      else
        @item_drawings_path = @item_request.item_drawing.file_packing_specifications.map { |drawing| drawing.url }
      end
      path_file_zip = "#{Rails.root}" + '/public' + File.dirname(@file_paths[0]) + '/' + @file_name_version + '_drawing_archive.zip' if @file_paths.present?

      if @item_drawings_path.present?
        folder_path = "#{Rails.root}" + '/public' + File.dirname(@item_drawings_path[0]) + '/'
        zipfile_name = @file_name_version + '_drawing_archive.zip'
        zipfile_path = folder_path + zipfile_name
        input_filenames = Dir.entries(folder_path).select { |f| !File.directory? f }
        file_zip = []
        Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
          input_filenames.each do |attachment|
            unless File.extname(attachment).eql? '.zip'
            file_zip << zipfile.add(attachment, File.join(folder_path, attachment))
            else
              FileUtils.rm_rf(Dir.glob(folder_path + '*.zip'))
            end
          end
        end
        if file_zip.present?
          OpenStruct.new(success?: true, path_file_zip: path_file_zip)
        else
          OpenStruct.new(success?: false)
        end
      else
        OpenStruct.new(success?: false)
      end
    end
  end
end
