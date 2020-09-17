# frozen_string_literal: true

module BuyerItemRequest
  extend ActiveSupport::Concern

  def set_item_request
    @item_request = current_user.item_requests.find_by(id: params[:id]) if current_user.buyer?
    redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') } if @item_request.blank?
  end
end
