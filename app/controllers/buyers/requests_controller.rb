class Buyers::RequestsController < Buyers::BaseController
  before_action :redirect_to_profile

  def create
    begin
      ActiveRecord::Base.transaction do
        @request = current_user.requests.new(supplier_id: params[:supplier_id])
        @request.save!
        @item_request = @request.item_requests.new(status: 1)
        @item_request.save!

        redirect_to buyers_item_info_index_path(item_request_id: @item_request.id), flash: { success: I18n.t('create.success') }
      rescue
        redirect_to search_provider_buyers_path, flash: { alert: I18n.t('create.failed') }
      end
    end
  end
end
