class Buyers::ItemRequestsController < Buyers::BaseController
  before_action :set_item_request

  def index
    @item_requests = current_user.item_requests.includes([:item_info]) if current_user.buyer?
    @item_requests = @item_requests.unsubmitted
  end

  def create
    @item_request = current_user.item_requests.new(supplier_id: params[:supplier_id], status: 0, creator: current_user.id)
    return redirect_to progress_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') } if @item_request.save

    redirect_to search_provider_buyers_path, flash: { alert: I18n.t('create.failed') }
  end

  def progress; end

  def complete; end

  def private_contract_progress; end

  # TODO:: FIX ME Do not have requirement
  def create_private_contract
    @item_request = current_user.item_requests.new(supplier_id: params[:supplier_id], status:  ItemRequest.status.find_value(:submitted).value, creator: current_user.id)
    return redirect_to private_contract_progress_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') } if @item_request.save

    redirect_to search_provider_buyers_path, flash: { alert: I18n.t('create.failed') }
  end

  def destroy
    @item_request.destroy!
    flash[:success] = "アイテム #{@item_request.id} を削除しました。"
    redirect_back(fallback_location:"/buyers/item_requests")
  end

  def submitted
    @item_request.update_attribute(:status, 7) if ItemRequest::STATUSES[@item_request.status.to_sym] == 6
    redirect_to complete_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
  end

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:id])
  end
end
