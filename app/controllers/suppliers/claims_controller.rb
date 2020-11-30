class Suppliers::ClaimsController < Suppliers::BaseController
  before_action :claims, :claim

  def table
    @count = 0
  end

  def edit
    @item_info = @claim&.item_request&.item_info
    @catalog = @claim&.item_request&.catalog
    @claims_images = @claim&.claims_image&.map { |image| image.url }
  end

  def update
    @claim.claims_cause = params.dig(:claim, :claims_cause) if params.dig(:claim, :claims_cause).present?
    @claim.claims_solution = params.dig(:claim, :claims_solution) if params.dig(:claim, :claims_solution).present?
    @claim.claim_cause_images = Dropzone::AddFilesService.new('claim', 'claim_cause_images', @claim.claim_cause_images, params).call
    @claim.claim_solution_images = Dropzone::AddFilesService.new('claim', 'claim_solution_images', @claim.claim_solution_images, params).call

    if @claim.save
      respond_to do |format|
        format.html { redirect_to table_suppliers_claims_path, success: I18n.t('update.success') }
        format.json { render json: @claim.id }
      end
    else
      flash.now[:alert] = I18n.t('update.failed')
      render :show
    end
  end

  def remove_claim
    if params[:index_of_claim_cause_images].present?
      remain_files = Dropzone::RemoveFileService.new(params[:index_of_claim_cause_images], @claim.claim_cause_images).call
      @claim.claim_cause_images = remain_files
      @claim.remove_claim_cause_images = true if remain_files.empty?
    elsif params[:index_of_claim_solution_images].present?
      remain_files = Dropzone::RemoveFileService.new(params[:index_of_claim_solution_images], @claim.claim_solution_images).call
      @claim.claim_solution_images = remain_files
      @claim.remove_claim_solution_images = true if remain_files.empty?
    end
    @claim.save
  end

  private

  def claims
    @claims = current_user.claims
  end

  def claim
    @claim = @claims.find_by(id: params[:id]) if @claims.present?
  end

  def claim_params
    if params.dig(:claim, :claim_cause_images)
      params[:claim][:claim_cause_images] = params[:claim][:claim_cause_images].values
    end
    params.require(:claim).permit(Claim::PARAMS_ATTRIBUTES_CLAIM_CAUSE)
  end

  def add_files(string, remain_files, params)
    added_files = remain_files
    added_files += params[:claim][string.to_sym].values if params.dig(:claim, string.to_sym)
    remain_files = added_files
  end
end
