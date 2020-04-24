class Users::RegistrationsController < Devise::RegistrationsController
  def create
    resource = Buyer.new(sign_up_params)

    unless resource.save
      if request.referrer == new_user_session_url
        session[:register_errors_for_new_user] = resource.errors
        return redirect_to new_user_session_path
      end

      if request.referrer == new_user_password_url
        session[:register_errors_for_new_password] = resource.errors
        return redirect_to new_user_password_path
      end
    end

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
