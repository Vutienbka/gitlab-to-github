class Buyers::ItemRequestsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[index destroy]

  def index
    @item_requests = current_user.item_requests.includes([:item_info]).all.ransack({ item_info_name_cont: params[:search] })
    @search_name = @item_requests.result.page(params[:page]).per(20)
  end

  def create
    @item_request = current_user.item_requests.new(supplier_id: params[:supplier_id], status: 1)
    return redirect_to buyers_item_info_index_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') } if @item_request.save

    redirect_to search_provider_buyers_path, flash: { alert: I18n.t('create.failed') }
  end

  def destroy
    @item_request.destroy!
    flash[:success] = I18n.t('destroy.success')
    redirect_to buyers_item_requests_path
  end

  def set_item_request
    @item_request = ItemRequest.find_by(params[:id])
  end
end
