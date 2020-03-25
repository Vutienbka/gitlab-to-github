class Users::SessionsController < Devise::SessionsController
  before_action :clear_session

  private

  def clear_session
    session.delete(:send_email_reset)
    session.delete(:count_to_show)
    session.delete(:register_errors_for_new_password)
    session.delete(:reset_password_success)
  end 
end