# frozen_string_literal: true

class Buyers::ItemStandardsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
    @item_image = ItemImage.find_or_create_by(item_request_id: @item_request&.id)

    if @item_image.image_categories.blank?
      ImageCategory::TYPES.each do |name|
        @item_image.image_categories.build(name: name).build_file_image
      end
    end

    @item_image.save
  end

  # def create
  #   @item_image = ItemImage.find_by(item_request_id: params[:item_image][:item_request_id])

  #   if @item_image.update(item_image_params)
  #     flash[:success] = I18n.t('create.success')
  #     @item_image.item_request.request&.update(request_status: Request::REQUEST_STATUSES[:quality])
  #     redirect_to buyers_item_quality_index_path(item_request_id: params[:item_image][:item_request_id])
  #     # Already redirect to next page at my_dropzone.js
  #   end
  # end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
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
