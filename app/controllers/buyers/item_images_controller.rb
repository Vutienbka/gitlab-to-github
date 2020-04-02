# frozen_string_literal: true

class Buyers::ItemImagesController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
    @item_image = ItemImage.find_or_create_by(item_request_id: @item_request&.id)
  end

  def create
    
  end

  private

    def set_item_request
      @item_request = ItemRequest.find_by(id: params[:item_request_id])
    end

    def item_image_params
      params.require(:item_image).permit(ItemImage::PARAMS_ATTRIBUTES)
    end
end
