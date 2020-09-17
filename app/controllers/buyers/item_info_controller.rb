# frozen_string_literal: true

class Buyers::ItemInfoController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_info, only: %i[edit update]

  def new
    if @item_request.item_info.present?
      return redirect_to root_path, flash: { alert: I18n.t('messages.cannot_register_because_the_item_already_exists') }
    end

    @item_info = @item_request.build_item_info
  end

  def create
    @item_info = @item_request.build_item_info(item_info_params)
    begin
      ActiveRecord::Base.transaction do
        @item_info.creator = current_user.id
        @item_info.save!
        if ItemRequest::STATUSES[@item_request.status.to_sym] < 2
          @item_request.update_attributes(item_info_id: @item_info.id, status: 2)
        end
        @item_request.update_attributes(creator: current_user.id)
        return redirect_to buyers_item_drawings_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue StandardError
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def edit; end

  def update
    @item_info.updater = current_user.id
    if @item_info.update(item_info_params)
      if ItemRequest::STATUSES[@item_request.status.to_sym] < 2
        @item_request.update_attributes(item_info_id: @item_info.id, status: 2)
      end
      @item_request.update_attributes(updater: current_user.id, updated_at: Time.current)
      return redirect_to edit_buyers_item_drawings_path(item_request_id: @item_request.id), flash: { success: I18n.t('update.success') }
    end

    flash.now[:alert] = I18n.t('update.failed')
    render :edit
  end

  private
  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:id])
  end

  def set_item_info
    @item_info = @item_request.item_info if @item_request.present?
    if @item_info.blank?
      redirect_to item_info_new_buyers_item_request_path(@item_request)
    end
  end

  def item_info_params
    params.require(:item_info).permit(ItemInfo::PARAMS_ATTRIBUTES)
  end
end
