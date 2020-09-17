# frozen_string_literal: true

class Buyers::ItemImagesController < Buyers::BaseController
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_image, only: %i[new create edit update]
  before_action :block_input_link, only: %i[new create edit update]

  def new
    # TODO: : bugs dropzone create duplicate record when redirec to buyers_item_images_path
    # Move this code to item drawing controller
  end

  def create
    if @item_image.update(item_image_params)
      flash[:success] = I18n.t('create.success')
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 4
        @item_request.update_attribute(:status, 4)
      end
      redirect_to buyers_item_qualities_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit; end

  def update
    if @item_image.update(item_image_params)
      flash[:success] = I18n.t('update.success')
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 4
        @item_request.update_attribute(:status, 4)
      end
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      redirect_to edit_buyers_item_qualities_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  private
  def set_item_image
    if @item_request.present?
      @item_image = ItemImage.includes(image_categories: :file_image)
                             .find_by(item_request_id: @item_request.id)
    end
  end

  def item_image_params
    ImageCategory::TYPES.each_with_index do |_key, index|
      if params.dig(:item_image, :image_categories_attributes, index.to_s, :file_image_attributes, :file_link)
        params[:item_image][:image_categories_attributes][index.to_s][:file_image_attributes][:file_link] = params[:item_image][:image_categories_attributes][index.to_s][:file_image_attributes][:file_link].values
      end
    end

    params.require(:item_image).permit(ItemImage::PARAMS_ATTRIBUTES)
  end

  def block_input_link
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
      redirect_to root_path
    end
  end
end
