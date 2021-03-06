# frozen_string_literal: true

class Buyers::ItemQualitiesController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_quality

  def new
    return redirect_to item_qualities_edit_buyers_item_request_path(@item_request) if @item_quality.present?

    @item_quality = @item_request.build_item_quality
  end

  def create
    @item_quality = @item_request.build_item_quality(item_quality_params)

    ActiveRecord::Base.transaction do
      @item_quality.creator = current_user.id
      @item_quality.save
      @item_request.update_attributes(status: get_count, updater: current_user.id)
      redirect_to item_standards_new_buyers_item_request_path(@item_request),  flash: { success: I18n.t('create.success') }
    rescue StandardError
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    redirect_to item_qualities_new_buyers_item_request_path(@item_request) if @item_quality.blank?
  end

  def update
    ActiveRecord::Base.transaction do
      @item_quality.updater = current_user.id
      @item_quality.update(item_quality_params)
      @item_request.update_attributes(status: get_count, updater: current_user.id)
      redirect_to item_standards_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
    rescue StandardError
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  private
  def set_item_quality
    @item_quality = @item_request.item_quality if @item_request.present?
  end

  def item_quality_params
    params.require(:item_quality).permit(ItemQuality::PARAMS_ATTRIBUTES)
  end
end
