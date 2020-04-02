# frozen_string_literal: true

class Buyers::ItemImagesController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new]

  def new; end

  def create
    @item_request = ItemRequest.find_by(id: params[:item_image][:item_request_id])
    if @item_request.present?
      @item_image = ItemImage.find_or_create_by(item_request_id: @item_request.id)
    end
    ActiveRecord::Base.transaction do
      @item_image.update(item_image_params)
      @item_request&.request&.update(request_status: Request::REQUEST_STATUSES[:quality])

      return redirect_to buyers_item_quality_index_path(item_request_id: params[:item_image][:item_request_id]), flash: { success: I18n.t('create.success') }
      # TO_DO redirect_to  standard_screen
    rescue StandardError
      redirect_to root_path, flash: { alert: I18n.t('create.failed') }
    end
  end

    private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    if @item_request.present?
      @item_image = ItemImage.find_or_create_by(item_request_id: @item_request.id)
    end
  end

  def item_image_params
    params.require(:item_image).permit(ItemImage::PARAMS_ATTRIBUTES)
  end
  end
