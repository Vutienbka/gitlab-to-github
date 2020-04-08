class BuyersController < UsersController
  skip_before_action :authenticate_user!, only: [:sign_up, :confirm_email]
  skip_before_action :redirect_to_profile, only: [:sign_up, :confirm_email]
  before_action :check_authentication_of_buyer, except: [:sign_up, :confirm_email] # Define at concerns/profile_setting.rb

  def invite_unregisted_supplier; end

  def send_email_invite
    @user = User.find_by(email: params[:invite][:email])
    return render :invite_unregisted_supplier, alert: t('messages.email_already_exists') if @user.present?

    current_user.user_invites.find_or_initialize_by(email_invited: params.dig('invite', 'email'), notify_status: 0).save
    BuyerMailer.send_mail_invite_unregisted_supplier(params, current_user).deliver_now
    flash[:success] = t('messages.please_wait_for_supplier_registration')
    redirect_to root_path
  end

  def register_item; end

  def search_provider
    @search = Supplier.ransack({ profile_company_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result.includes(:profile)
  end

  def sign_up
    invited_users = UserInvite.where(email_invited: buyer_params[:email], notify_status: 0)
    @user = Buyer.new(buyer_params)
    @user = Supplier.new(buyer_params) if invited_users.present?
    return redirect_to new_user_session_path, notice: t('devise.confirmations.send_instructions') if @user.save
    session[:register_buyer_errors] = @user.errors
    redirect_to new_user_session_path
  end

  def confirm_email
    @user = User.find_by(token: params[:token])
    @user.update_attribute(:token, nil)
    redirect_to new_user_session_path, notice: t('devise.confirmations.confirmed')
  end

  def batch_items_register
  end

  private

  def buyer_params
    params.require(:buyer).permit(:email, :password, :password_confirmation)
  end
end
