# frozen_string_literal: true

class Buyers::ItemQuotationsController < Buyers::BaseController
  before_action :set_item_request, only: %i[new send_mailer_quotation]
  before_action :block_input_link, only: %i[new create edit update]

  def new; end

  def send_mailer_quotation
    @supplier = Supplier.find_by(id: @item_request.supplier_id.to_s)
    email = @supplier
    buyer = current_user
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 9
      @item_request.update_attribute(:status, 9)
    end
    if QuotationMailer.send_maill_quotation_items(email, buyer).deliver_now
      redirect_to item_cost_down_buyers_path(item_request_id: @item_request.id), flash: { success: '見積依頼メールがサプライヤーに送信しました。' }
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    unless @item_request.present? && @item_request&.buyer_id == current_user.id
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
  end

  def block_input_link
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 8
      redirect_to root_path
    end
  end
end
