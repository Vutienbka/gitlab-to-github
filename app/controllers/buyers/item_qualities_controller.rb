# frozen_string_literal: true

class Buyers::ItemQualitiesController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_quality, only: %i[create edit update]

  def new
    @item_quality = ItemQuality.find_or_create_by(item_request_id: @item_request&.id)
  end

  def create
    ActiveRecord::Base.transaction do
      @item_quality.update(item_quality_params)
      @item_request.update_attribute(:status, 5) if ItemRequest::STATUSES[@item_request.status.to_sym] < 5
      flash[:success] = I18n.t('create.success')
      return redirect_to buyers_item_standards_path(item_request_id: @item_request.id)
    rescue StandardError
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    if @item_quality.quality1 == 0 && @item_quality.quality2 == 0 && 
      @item_quality.quality3 == 0 && @item_quality.quality4 == 0 && 
      @item_quality.quality5 == 0 && @item_quality.quality6 == 0 && 
      @item_quality.quality7 == 0 && @item_quality.quality8 == 0 && 
      @item_quality.quality9 == 0 && @item_quality.quality10 == 0 && 
      @item_quality.quality11 == 0 && @item_quality.quality12 == 0 && 
      @item_quality.quality13 == 0 && @item_quality.quality14 == 0 && 
      @item_quality.quality15 == 0 && @item_quality.quality16 == 0

      redirect_to buyers_item_qualities_path(item_request_id: @item_request.id)
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @item_quality.update(item_quality_params)
      @item_request.update_attribute(:status, 5) if ItemRequest::STATUSES[@item_request.status.to_sym] < 5
      flash[:success] = I18n.t('update.success')
      return redirect_to edit_buyers_item_standards_path(item_request_id: @item_request.id)
    rescue StandardError
      flash[:alert] = I18n.t('update.failed')
      render :new
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    unless @item_request.present? && @item_request&.request&.buyer == current_user
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
  end

  def set_item_quality
    @item_quality = ItemQuality.find_by(item_request_id: @item_request.id)
  end

  def item_quality_params
    params.require(:item_quality).permit(ItemQuality::PARAMS_ATTRIBUTES)
  end
end
