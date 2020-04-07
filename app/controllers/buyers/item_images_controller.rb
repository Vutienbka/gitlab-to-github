# frozen_string_literal: true

class Buyers::ItemImagesController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update destroy]
  before_action :set_item_image, only: %i[create edit update destroy]

  def new
    return redirect_to root_path, flash: {alert: I18n.t('messages.cannot_register_because_the_item_already_exists')} if @item_request.item_image.present?

    @item_image = ItemImage.find_or_create_by(item_request_id: @item_request&.id)

    if @item_image.image_categories.blank?
      ImageCategory::TYPES.each do |name|
        @item_image.image_categories.build(name: name).build_file_image
      end
    end

    @item_image.save
  end

  def create
    if @item_image.update(item_image_params)
      flash[:success] = I18n.t('create.success')
      @item_request.update_attribute(:status, 4)
      redirect_to buyers_item_quality_index_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
    end
  end

  def edit
  end

  def update
    if @item_image.update(item_image_params)
      flash[:success] = I18n.t('update.success')
      @item_image.item_request.request&.update(request_status: Request::REQUEST_STATUSES[:quality])
      redirect_to buyers_item_quality_index_path(item_request_id: @item_request.id)
      # Already redirect to next page at my_dropzone.js
      # TODO:: redirect to edit next page
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.request&.buyer == current_user
  end

  def set_item_image
    @item_image = ItemImage.find_by(item_request_id: @item_request.id)
  end

  def item_image_params
    ImageCategory::TYPES.each_with_index do |key, index|
      if params.dig(:item_image, :image_categories_attributes, index.to_s, :file_image_attributes, :file_link)
        params[:item_image][:image_categories_attributes][index.to_s][:file_image_attributes][:file_link] = params[:item_image][:image_categories_attributes][index.to_s][:file_image_attributes][:file_link].values
      end
    end

    params.require(:item_image).permit(ItemImage::PARAMS_ATTRIBUTES)
  end
end
