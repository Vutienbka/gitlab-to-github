# frozen_string_literal: true

class Buyers::ItemSamplesController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_sample, only: %i[new create edit update]

  def new; end

  def create
    ActiveRecord::Base.transaction do
      @item_sample.creator = current_user.id
      @item_sample.update(item_sample_params)
      @item_sample.save
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
        @item_request.update_attribute(:status, 7)
      end
      flash[:success] = I18n.t('create.success')
      redirect_to new_buyers_item_quotation_path(item_request_id: @item_request.id)
    rescue StandardError
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @item_sample.update(item_sample_params)
      @item_sample.save
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
        @item_request.update_attribute(:status, 7)
      end
      flash[:success] = I18n.t('update.success')
      redirect_to new_buyers_item_quotation_path(item_request_id: @item_request.id)
    rescue StandardError
      flash[:alert] = I18n.t('update.failed')
      render :new
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    unless @item_request.present? && @item_request&.buyer_id == current_user.id
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
  end

  def set_item_sample
    @item_sample = ItemSample.find_or_initialize_by(item_request_id: @item_request.id)
    set_sample_category_id
  end

  def item_sample_params
    params.require(:item_sample).permit(ItemSample::PARAMS_ATTRIBUTES)
  end

  def set_sample_category_id
    @item_sample.sample_category1_id = 1
    @item_sample.sample_category2_id = 2
    @item_sample.sample_category3_id = 3
    @item_sample.sample_category4_id = 4
  end
end
