# frozen_string_literal: true

class Buyers::ItemQualityController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new; end

  def create
    ActiveRecord::Base.transaction do
      @item_quality.update(item_quality_params)
      @item_request&.request&.update(request_status: Request::REQUEST_STATUSES[:standard])
      return redirect_to root_path, flash: { success: I18n.t('create.success') }
      # TO_DO redirect_to  standard_screen
    rescue StandardError
      redirect_to root_path, flash: { alert: I18n.t('create.failed') }
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    if @item_request.present?
      @item_quality = ItemQuality.find_or_create_by(item_request_id: @item_request.id)
    end
  end

  def item_quality_params
    params.require(:item_quality).permit(ItemQuality::PARAMS_ATTRIBUTES)
  end
end
