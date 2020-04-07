class Buyers::InspectionRequestsController < Buyers::BaseController
  def new
    @inspection_request = InspectionRequest.new
  end

  def create
    @inspection_request = current_user.inspection_requests.build(suppliers_params)
    if @inspection_request.save
      flash[:success] = I18n.t('create.success')
      BuyerMailer.send_mail_inspection_request(@inspection_request, current_user).deliver_now
      redirect_to status_inspect_users_path
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def suppliers_params
    params.require(:inspection_request).permit(:inspect_address, :inspect_tel, :inspect_company_name, :request_type)
  end
end
