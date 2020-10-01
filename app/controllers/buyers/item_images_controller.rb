# frozen_string_literal: true

class Buyers::ItemImagesController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_image, except: %i[create]

  def new
    return redirect_to item_images_edit_buyers_item_request_path(@item_request) if @item_image.present?

    @item_image = @item_request.build_item_image
  end

  def create
    @item_image = @item_request.build_item_image(item_image_params)

    if @item_image.save
      @item_request.update_attribute(:status, get_count)
      respond_to do |format|
        format.html { redirect_to item_qualities_new_buyers_item_request_path(@item_request), success: I18n.t('create.success') }
        format.json { render json: @item_image }
      end
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    redirect_to item_images_new_buyers_item_request_path(@item_request) if @item_image.blank?
  end

  def update
    @item_image.file_images = add_files('file_images', @item_image.file_images, params)

    if @item_image.save
      @item_request.update_attribute(:status, get_count)
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      respond_to do |format|
        format.html { redirect_to item_qualities_edit_buyers_item_request_path(@item_request), success: I18n.t('update.success') }
        format.json { render json: @item_image }
      end
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  def remove_file
    if params[:index_of_file_images].present?
      images_remain_files = remove(params[:index_of_file_images], @item_image.file_images)
      @item_image.file_images = images_remain_files
      @item_image.remove_file_images = true if images_remain_files.empty?
    end

    @item_request.update_attributes(updater: current_user.id, updated_at: Time.current) if @item_image.save
  end

  private
  def set_item_image
    @item_image = @item_request.item_image if @item_request.present?
  end

  def item_image_params
    params[:item_image][:file_images] = params[:item_image][:file_images].values if params.dig(:item_image, :file_images)
    params.require(:item_image).permit(ItemImage::PARAMS_ATTRIBUTES)
  end

  def add_files(string, remain_files, params)
    added_files = remain_files
    added_files += params[:item_image][string.to_sym].values if params.dig(:item_image, string.to_sym)
    remain_files = added_files
  end

  def remove(index_of, remain_files)
    index = index_of.to_i
    current_files = remain_files # copy the array
    deleted_file = current_files.delete_at(index) # delete the target image
    deleted_file.try(:remove!) # delete image from S3
    remain_files = current_files # re-assign back
  end
end
