class Buyers::FileDrawsController < Buyers::BaseController
  before_action :find_item_drawing, only: [:create, :destroy]

  def create
    add_more_images(file_draw_params[:file_link])
    flash[:error] = "Failed uploading images" unless @draw_category.save
    @item_drawing.update_attributes(updater: current_user.id)
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = "Failed deleting image" unless @draw_category.save
    @item_drawing.update_attributes(updater: current_user.id)
  end

  private
  def find_item_drawing
    @item_drawing = ItemDrawing.find_by(id: params[:item_drawing_id])
    @draw_category = DrawCategory.find_by(id: params[:draw_category_id])
  end

  def file_draw_params
    if params.dig(:file_draw, :file_link)
      params[:file_draw][:file_link] = params[:file_draw][:file_link].values
    end
    params.require(:file_draw).permit({ file_link:[] })
  end

  def remove_image_at_index(index)
    remain_images = @draw_category.file_draw.file_link # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @draw_category.file_draw.file_link = remain_images # re-assign back

    if remain_images.length == 0
      @draw_category.file_draw.remove_file_link = true
    end
  end

  def add_more_images(new_images)
    images = @draw_category.file_draw.file_link
    images += new_images
    @draw_category.file_draw.file_link = images
  end
end
