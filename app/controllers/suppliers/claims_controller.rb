class Suppliers::ClaimsController < Suppliers::BaseController
  before_action :claims, only: %i[table show submit_show submit_show_modal]
  before_action :claim, only: %i[table show submit_show submit_show_modal]

  def index; end

  def table
    @claims_list = current_user.claims.where(supplier_id= current_user.id.to_s)
    @count = 0
  end

  def show
    @current_claim = @claims.find_by(id: params[:id])
    @item_info = @current_claim&.item_request&.item_info
    @catalog = @current_claim&.item_request&.catalog
    @claims_images = @current_claim&.claims_image&.map { |image| image.url }
  end

  def submit_show
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
    begin
      ActiveRecord::Base.transaction do
        @claim.update(claims_params)
        redirect_to table_suppliers_claims_path
    rescue StandardError
        flash[:alert] = I18n.t('update.failed')
        render :table
      end
    end
  end

  def submit_show_modal
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
    begin
      ActiveRecord::Base.transaction do
        @claim.claims_solution = params[:claim][:claims_solution]
        @claim.save
        redirect_to table_suppliers_claims_path
    rescue StandardError
      flash[:alert] = I18n.t('update.failed')
      render :table
      end
    end
  end

  def claims
    @claims = current_user.claims
  end

  def claim
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
  end

  def claims_params
    params.require(:claim).permit(Claim::PARAMS_ATTRIBUTES_CLAIM_CAUSE)
  end

  def add_files(string, remain_files, params)
    added_files = remain_files
    added_files += params[:claim][string.to_sym].values if params.dig(:claim, string.to_sym)
    remain_files = added_files
  end
end