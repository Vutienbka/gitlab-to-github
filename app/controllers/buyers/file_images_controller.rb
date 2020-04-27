# frozen_string_literal: true

class Buyers::FileImagesController < Buyers::BaseController
  before_action :find_item_image, only: %i[create destroy]

  def create
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    unless @item_request.present? && @item_request&.buyer_id == current_user.id
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 4
      @item_request.update_attribute(:status, 4)
    end
    add_more_images(file_image_params[:file_link])
    flash[:error] = 'Failed uploading images' unless @image_category.save
    @item_image.update_attributes(updater: current_user.id)
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = 'Failed deleting image' unless @image_category.save
    @item_image.update_attributes(updater: current_user.id)
  end

  private

  def find_item_image
    @item_image = ItemImage.find_by(id: params[:item_image_id])
    @image_category = ImageCategory.find_by(id: params[:image_category_id])
  end

  def file_image_params
    if params.dig(:file_image, :file_link)
      params[:file_image][:file_link] = params[:file_image][:file_link].values
    end
    params.require(:file_image).permit({ file_link: [] })
  end

  def remove_image_at_index(index)
    remain_images = @image_category.file_image.file_link # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @image_category.file_image.file_link = remain_images # re-assign back

    @image_category.file_image.remove_file_link = true if remain_images.empty?
  end

  def add_more_images(new_images)
    images = @image_category.file_image.file_link
    images += new_images
    @image_category.file_image.file_link = images
  end
end
