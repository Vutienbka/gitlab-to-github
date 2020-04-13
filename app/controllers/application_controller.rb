class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_item_requests_quantity
 
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :basic_auth

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected 
  def configure_permitted_parameters
    added_attrs = [:email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
 
  def after_sign_in_path_for(resource)
    return buyers_profiles_path if current_user.profile.blank?
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  private

  def basic_auth
    return unless Rails.env.staging?

    username = 'newjiapp'
    password = 'appnewji'
    authenticate_or_request_with_http_basic do |user, pass|
      user == username && pass == password
    end
  end

  def get_item_requests_quantity
    if current_user.present? && (current_user.buyer? || current_user.both?)
      @item_requests_quantity = current_user.item_requests.count
    end
  end
end
