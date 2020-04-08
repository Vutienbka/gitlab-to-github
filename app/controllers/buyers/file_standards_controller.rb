class Buyers::FileStandardsController < Buyers::BaseController
  before_action :find_item_standard, only: [:create, :destroy]

  def create
    add_more_images(file_standard_params[:file_link])
    flash[:error] = "Failed uploading images" unless @standard_category.save
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = "Failed deleting image" unless @standard_category.save
  end

  private
  def find_item_standard
    @item_standard = ItemStandard.find_by(id: params[:item_standard_id])
    @standard_category = StandardCategory.find_by(id: params[:standard_category_id])
  end

  def file_standard_params
    if params.dig(:file_standard, :file_link)
      params[:file_standard][:file_link] = params[:file_standard][:file_link].values
    end
    params.require(:file_standard).permit({ file_link:[] })
  end
  
  def remove_image_at_index(index)
    remain_images = @standard_category.file_standard.file_link # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @standard_category.file_standard.file_link = remain_images # re-assign back
    
    if remain_images.length == 0
      @standard_category.file_standard.remove_file_link = true
    end
  end

  def add_more_images(new_images)
    images = @standard_category.file_standard.file_link
    images += new_images
    @standard_category.file_standard.file_link = images
  end
end
