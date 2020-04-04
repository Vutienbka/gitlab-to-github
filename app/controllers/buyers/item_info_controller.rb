class Buyers::ItemInfoController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_info, only: %i[edit update]

  def new
    session[:check_number_on_progress] = 1 if session[:check_number_on_progress].nil?
    return redirect_to root_path if @item_request.item_info.present?

    @item_info = ItemInfo.new()
  end

  def create
    @item_info = ItemInfo.new(item_info_params)
    @item_info.item_request_id = params[:item_request_id]
    begin
      ActiveRecord::Base.transaction do
        @item_info.save!
        @item_request.request&.update(request_status: Request::REQUEST_STATUSES[:draw])

        return redirect_to buyers_item_drawings_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def edit
    session[:check_number_on_progress] = 1 if session[:check_number_on_progress].nil?
  end

  def update
    return redirect_to buyers_item_drawings_path(item_request_id: @item_request.id), flash: { success: I18n.t('update.success') } if @item_info.update(item_info_params)

    flash.now[:alert] = I18n.t('update.failed')
    render :edit
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.request&.buyer == current_user
  end

  def set_item_info
    @item_info = ItemInfo.find_by(item_request_id: params[:item_request_id])
  end

  def item_info_params
    params.require(:item_info).permit(ItemInfo::PARAMS_ATTRIBUTES)
  end
end
