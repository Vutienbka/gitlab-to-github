class Buyers::ContractsController < Buyers::BaseController
  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      respond_to do |format|
        format.html { redirect_to search_provider_buyers_path, flash: { success: I18n.t("create.success") } }
        format.json { render json: @contract }
      end
    else
      flash[:alert] = I18n.t("create.failed")
      render :new
    end
  end

  def contract_params
    params[:contract][:contract_data] = params[:contract][:contract_data].values if params.dig(:contract, :contract_data)
    params.require(:contract).permit(Contract::PARAMS).merge!(user_id: current_user.id, profile_id: current_user.profile.id)
  end
end
