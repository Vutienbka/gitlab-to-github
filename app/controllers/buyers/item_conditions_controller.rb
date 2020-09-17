# frozen_string_literal: true

class Buyers::ItemConditionsController < Buyers::BaseController
  before_action :set_item_request, only: %i[new edit create update destroy_condition]
  before_action :set_item_condition, only: %i[edit update destroy_condition]
  before_action :block_input_link, only: %i[new edit create update]
  def new
    @item_request.item_conditions.build
  end

  def create
    ActiveRecord::Base.transaction do
      @item_request.update!(item_request_params)
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
        @item_request.update_attribute(:status, 7)
      end
      return redirect_to buyers_item_samples_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
    rescue StandardError
      flash.now[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit; end

  def update
    if @item_request.update(item_request_params)
      flash[:success] = I18n.t('update.success')
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
        @item_request.update_attribute(:status, 7)
      end
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      redirect_to edit_buyers_item_samples_path(item_request_id: @item_request.id)
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  def destroy_condition
    @item_condition = ItemCondition.find_by(id: params['format'])
    @item_condition.destroy
    redirect_to edit_buyers_item_conditions_path(item_request_id: @item_request.id)
  end

  private
  def set_item_condition
    if @item_request.present?
      @item_condition = ItemCondition.find_or_initialize_by(item_request_id: @item_request.id)
    end
  end

  def item_request_params
    params.require(:item_request).permit(ItemRequest::PARAMS_ATTRIBUTES)
  end

  def block_input_link
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 6
      redirect_to root_path
    end
  end
end
