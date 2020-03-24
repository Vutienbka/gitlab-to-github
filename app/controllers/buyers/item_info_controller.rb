class Buyers::ItemInfoController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @item_info.update(item_info_params)
        @item_request.request&.update(request_status: Request::REQUEST_STATUSES[:draw])

        return redirect_to buyers_item_drawings_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue
        redirect_to root_path, flash: { alert: I18n.t('create.success') }
        # TODO:: render new
      end
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    @item_info = ItemInfo.find_or_initialize_by(item_request_id: @item_request.id) if @item_request.present?
  end

  def item_info_params
    params.require(:item_info).permit(ItemInfo::PARAMS_ATTRIBUTES)
  end
end
