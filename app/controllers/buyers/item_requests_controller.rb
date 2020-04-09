class Buyers::ItemRequestsController < Buyers::BaseController
  before_action :redirect_to_profile

  def create
    @item_request = current_user.item_requests.new(supplier_id: params[:supplier_id], status: 1)
    return redirect_to buyers_item_info_index_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') } if @item_request.save

    redirect_to search_provider_buyers_path, flash: { alert: I18n.t('create.failed') }
  end
end
