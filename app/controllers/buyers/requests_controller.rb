class Buyers::RequestsController < Buyers::BaseController
  before_action :redirect_to_profile

  def create
    params[:supplier_id] = 2
    # TODO:: Get supplier_id from params
    begin
      ActiveRecord::Base.transaction do
        @request = current_user.requests.new(supplier_id: params[:supplier_id], request_status: Request::REQUEST_STATUSES[:information])
        @request.save
        @item_request = @request.item_requests.new
        @item_request.save

        return redirect_to buyers_item_info_index_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue
        flash.now = I18n.t('create.failed')
        return redirect_to root_path
        # TODO:: render to /search_provider
      end
    end
  end
end
