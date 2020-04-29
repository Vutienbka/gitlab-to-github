# frozen_string_literal: true

module BuyerItemRequest
  extend ActiveSupport::Concern

  def set_item_request
    @item_request = current_user.item_requests.find_by(id: params[:item_request_id])
    if @item_request.blank?
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
  end
end
