# frozen_string_literal: true

class Buyers::ItemConditionsController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_condition, except: %i[create]

  def new
    return redirect_to item_conditions_edit_buyers_item_request_path(@item_request) if @item_conditions.present?

    @item_request.item_conditions.build
  end

  def create
    ActiveRecord::Base.transaction do
      count = get_count
      @item_request.update!(item_request_params)
      @item_request.update_attribute(:status, count)
      return redirect_to complete_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') } if count == 6
      redirect_to progress_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') } 
    rescue StandardError
      flash.now[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
    redirect_to item_conditions_new_buyers_item_request_path(@item_request) if @item_conditions.blank?
  end

  def update
    ActiveRecord::Base.transaction do
      count = get_count
      @item_request.update(item_request_params)
      @item_request.update_attribute(:status, count)
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      return redirect_to complete_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') } if count == 6
      redirect_to progress_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
    rescue StandardError
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  private

  def set_item_condition
    @item_conditions = @item_request.item_conditions if @item_request.present?
  end

  def item_request_params
    params.require(:item_request).permit(ItemRequest::PARAMS_ATTRIBUTES)
  end
end
