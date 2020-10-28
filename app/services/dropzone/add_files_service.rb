module Dropzone
  class AddFilesService
    def initialize(model_string, field_string, remain_files, params)
      @model_string = model_string
      @field_string = field_string
      @remain_files = remain_files
      @params = params
    end

    def call
      added_files = @remain_files
      added_files += @params[@model_string.to_sym][@field_string.to_sym].values if @params.dig(@model_string.to_sym, @field_string.to_sym)
      @remain_files = added_files
    end
  end
end
