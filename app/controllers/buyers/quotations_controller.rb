class Buyers::QuotationsController < Buyers::BaseController
  before_action :set_item_request, only: %i[ new send_mailer_quotation]

  def new
  end

  def send_mailer_quotation
    @request = Request.find_by(id: "#{@item_request.request_id}")
    @supplier = Supplier.find_by(id: "#{@request.supplier_id}")
    email = @supplier
    buyer = current_user
    return redirect_to root_path, flash: {success: '見積依頼メールがサプライヤーに送信しました。'} if QuotationMailer.send_maill_quotation_items(email, buyer).deliver_now
  end

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
  end
end
