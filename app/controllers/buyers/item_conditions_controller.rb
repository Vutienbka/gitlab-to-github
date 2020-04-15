class Buyers::ItemConditionsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new edit create update destroy destroy_condition]
  def new
    @item_request.item_conditions.build
  end
  def create
    begin
      ActiveRecord::Base.transaction do
        @item_request.update!(item_request_params)
        @item_request.update_attribute(:status, 7) if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
        return redirect_to buyers_item_samples_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @item_request.update(item_request_params)
      flash[:success] = I18n.t('update.success')
      @item_request.update_attribute(:status, 7) if ItemRequest::STATUSES[@item_request.status.to_sym] < 7
      redirect_to buyers_item_samples_path(item_request_id: @item_request.id)
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  def destroy_condition
    @item_condition = ItemCondition.find_by(id: params["format"])
    @item_condition.destroy
    redirect_to edit_buyers_item_conditions_path(item_request_id: @item_request.id)
  end

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.buyer_id == current_user.id

    @item_condition = ItemCondition.find_or_initialize_by(item_request_id: @item_request.id) if @item_request.present?
  end

  def item_request_params
    params.require(:item_request).permit(ItemRequest::PARAMS_ATTRIBUTES)
  end
end
