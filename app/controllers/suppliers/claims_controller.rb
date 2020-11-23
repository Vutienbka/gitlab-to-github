class Suppliers::ClaimsController < Suppliers::BaseController
  before_action :claims, only: %i[table show submit_show]
  before_action :claim, only: %i[table show submit_show]

  def index; end

  def table
    if params[:q].blank?
      if params[:item_code].blank? || (params[:item_code] == 'blank')
        @q = @claims.ransack(params[:q])
      else
        @item_info = ItemInfo.find_by(SKU: params[:item_code])
        @item_request = @item_info&.item_request
        @q = @item_request&.claims.where(buyer_id: current_user.id).ransack(params[:q])
      end
      @claims = @q.result.page(params[:page]).per 10
    end
  end

  def show
    @current_claim = @claims.find_by(id: params[:id])
    @item_info = @current_claim&.item_request&.item_info
    @catalog = @current_claim&.item_request&.catalog
    @claims_images = @current_claim&.claims_image&.map { |image| image.url }
  end

  def submit_show
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
    @claim.claims_solution = params[:claim][:claims_solution]
    @claim.claims_cause = params[:claim][:claims_cause]
    @claim.save
    redirect_to table_buyers_claims_path
  end

  def claims
    @claims = current_user.claims
  end

  def claim
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
  end
end