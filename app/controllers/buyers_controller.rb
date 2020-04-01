class BuyersController < UsersController
  skip_before_action :authenticate_user!, only: [:sign_up, :confirm_email]
  skip_before_action :redirect_to_profile, only: [:sign_up, :confirm_email]

  def invite_unregisted_supplier
  end

  def send_email_invite
    buyer = current_user
    return redirect_to root_path, flash: {success: 'サプライヤーのご登録をお待ちください'} if BuyerMailer.send_mail_invite_unregisted_supplier(params, buyer).deliver_now
  end


  def search_provider
    @search = Supplier.ransack({ profile_company_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result
  end

  def sign_up
    @buyer = Buyer.new(buyer_params)
    return redirect_to new_user_session_path, notice: t('devise.confirmations.send_instructions') if @buyer.save
    session[:register_buyer_errors] = @buyer.errors
    binding.pry
    redirect_to new_user_session_path
  end

  def confirm_email
    @buyer = Buyer.find_by(token: params[:token])
    @buyer.update_attribute(:token, nil)
    redirect_to new_user_session_path, notice: t('devise.confirmations.confirmed')
  end

  private

  def buyer_params
    params.require(:buyer).permit(:email, :password, :password_confirmation)
  end
end
