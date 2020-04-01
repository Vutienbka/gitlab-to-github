class Users::PasswordsController < DeviseController
  before_action :clear_session
  prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      session.delete(:register_errors_for_new_password)
      session[:send_email_reset] = true
    else
      session[:register_errors_for_new_password] = resource.errors
      session[:count_to_show] = 0 if session[:count_to_show].blank?
      session[:count_to_show] += 1
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      # Override after resetting password
      random_fake_token = random_str
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message!(:notice, flash_message)
      session[:reset_password_success] = true
      resource.send_password_change_notification
      return redirect_to edit_user_password_path(reset_password_token: "#{random_fake_token}")
    else
      flash[:alert] = I18n.t('update.failed')
      set_minimum_password_length
      respond_with resource
    end
  end

  protected
    def after_resetting_password_path_for(resource)
      Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_user_password_path if is_navigational_format?
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
        resource.respond_to?(:unlock_strategy_enabled?) &&
        resource.unlock_strategy_enabled?(:email)
    end

    def translation_scope
      'devise.passwords'
    end

    def clear_session
      session.delete(:register_errors_for_new_user)
    end

    def random_str(len = 6, character_set = ['A'..'Z', '0'..'9'])
      chars = character_set.map { |x| x.is_a?(Range) ? x.to_a : x }.flatten
      Array.new(len) { chars.sample }.join
    end
end
