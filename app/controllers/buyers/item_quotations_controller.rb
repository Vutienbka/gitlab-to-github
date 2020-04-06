class Buyers::ItemQuotationsController < Buyers::BaseController
  before_action :set_item_request, only: %i[ new send_mailer_quotation]

  def new
    session[:check_number_on_progress] += 1 if session[:check_number_on_progress].to_i == 7
  end

  def send_mailer_quotation
    @request = Request.find_by(id: "#{@item_request.request_id}")
    @supplier = Supplier.find_by(id: "#{@request.supplier_id}")
    email = @supplier
    buyer = current_user
    return redirect_to item_cost_down_buyers_path(item_request_id: @item_request.id), flash: {success: '見積依頼メールがサプライヤーに送信しました。'} if QuotationMailer.send_maill_quotation_items(email, buyer).deliver_now
  end

  private
  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.request&.buyer == current_user
  end
end
