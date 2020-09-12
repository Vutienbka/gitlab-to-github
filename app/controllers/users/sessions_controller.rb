class Users::SessionsController < Devise::SessionsController
  before_action :clear_session

  def new
    @buyer = Buyer.new
    @buyer_error = session[:register_buyer_errors] if session[:register_buyer_errors].present?
    session[:register_buyer_errors] = nil
    super
  end

  def create
    super
  end

  private

  def clear_session
    session.delete(:send_email_reset)
    session.delete(:count_to_show)
    session.delete(:register_errors_for_new_password)
    session.delete(:reset_password_success)
  end
end
