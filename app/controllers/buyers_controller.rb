# frozen_string_literal: true

class BuyersController < UsersController
  skip_before_action :authenticate_user!, only: %i[sign_up confirm_email]
  skip_before_action :redirect_to_profile, only: %i[sign_up confirm_email]
  load_and_authorize_resource

  def invite_unregisted_supplier; end

  def status_inspect; end

  def send_email_invite
    @user = User.find_by(email: params[:invite][:email])
    if @user.present?
      flash[:success] = t('messages.email_already_exists')
      return render :invite_unregisted_supplier
    end

    current_user.user_invites.find_or_initialize_by(email_invited: params.dig('invite', 'email'), notify_status: 0).save
    BuyerMailer.send_mail_invite_unregisted_supplier(params, current_user).deliver_now
    flash[:success] = t('messages.please_wait_for_supplier_registration')
    redirect_to root_path
  end

  def register_item; end

  def search_provider
    return @search = Supplier.ransack if params[:search].blank?

    @search = Supplier.ransack({ profile_first_name_or_profile_last_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result.includes(:profile)
  end

  def search_supplier_import
    return @search = Supplier.ransack if params[:search].blank?

    @search = Supplier.ransack({ profile_first_name_or_profile_last_name_or_profile_code_cont: params[:search] })
    @search_suppliers = @search.result.includes(:profile)
  end

  def sign_up
    invited_users = UserInvite.where(email_invited: buyer_params[:email], notify_status: 0)
    @user = Buyer.new(buyer_params)
    @user = Supplier.new(buyer_params) if invited_users.present?
    if @user.save
      return redirect_to new_user_session_path, notice: t('devise.confirmations.send_instructions')
    end

    session[:register_buyer_errors] = @user.errors
    redirect_to new_user_session_path
  end

  def confirm_email
    @user = User.find_by(token: params[:token])
    @user.update_attribute(:token, nil)
    redirect_to new_user_session_path, notice: t('devise.confirmations.confirmed')
  end

  def item_cost_down
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    unless @item_request.present? && @item_request&.buyer_id == current_user.id
      redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') }
    end
    if ItemRequest::STATUSES[@item_request.status.to_sym] < 9
      redirect_to root_path
    end
  end

  def batch_items_register; end

  private

  def buyer_params
    params.require(:buyer).permit(:email, :password, :password_confirmation)
  end
end
