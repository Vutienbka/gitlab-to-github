class BuyersController < UsersController
  skip_before_action :authenticate_user!, only: [:sign_up, :confirm_email]
  skip_before_action :redirect_to_profile, only: [:sign_up, :confirm_email]
  before_action :check_authentication_of_buyer # Define at concerns/profile_setting.rb

  def invite_unregisted_supplier; end

  def send_email_invite
    @supplier = User.find_by(email: params[:invite][:email])
    
    if @supplier.blank?
      BuyerMailer.send_mail_invite_unregisted_supplier(params, current_user).deliver_now
      flash[:success] = t('messages.please_wait_for_supplier_registration')
      return redirect_to root_path
    end

    flash.now[:alert] = t('messages.email_already_exists')
    render :invite_unregisted_supplier
  end

  def register_item; end

  def search_provider
    @search = Supplier.ransack({ profile_company_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result.includes(:profile)
  end

  def sign_up
    @buyer = Buyer.new(buyer_params)
    return redirect_to new_user_session_path, notice: t('devise.confirmations.send_instructions') if @buyer.save
    session[:register_buyer_errors] = @buyer.errors
    redirect_to new_user_session_path
  end

  def confirm_email
    @buyer = Buyer.find_by(token: params[:token])
    @buyer.update_attribute(:token, nil)
    redirect_to new_user_session_path, notice: t('devise.confirmations.confirmed')
  end

  def batch_items_register
    
  end

  private

  def buyer_params
    params.require(:buyer).permit(:email, :password, :password_confirmation)
  end
end
