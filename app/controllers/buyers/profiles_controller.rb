class Buyers::ProfilesController < Buyers::BaseController
  before_action :redirect_to_profile, except: %i[new create]
  before_action :clear_session
  before_action :set_buyer, only: %i[edit update set_account update_account]

  def new
    return redirect_to root_path if current_user.profile.present?
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile
    if current_user.update(buyer_params)
      invited_users = UserInvite.where(email_invited: current_user.email, notify_status: 0)
      if invited_users.present? && current_user.is_a?(Supplier)
        User.where(id: invited_users.pluck(:user_id)).each do |buyer|
          BuyerMailer.send_mail_after_supplier_invited_register(buyer, current_user).deliver_now
        end
        invited_users.update_all(notify_status: 1)
      end
      return redirect_to set_account_buyers_profiles_path, flash: { success: I18n.t('create.success') }
    end

    flash.now[:alert] = I18n.t('create.failed')
    render :new
  end

  def edit; end

  def update
    return redirect_to set_account_buyers_profiles_path, flash: { success: I18n.t('update.success') } if current_user.update(buyer_params)

    flash.now[:alert] = I18n.t('update.failed')
    render :edit
  end

  def set_account; end

  def update_account
    begin
      ActiveRecord::Base.transaction do
        require = convert_type(current_user.type)
        return redirect_to root_path, flash: { success: I18n.t('update.success') } if current_user.type == params[require][:type]

        value = { "#{require.to_s}_id": nil, type: "#{params[require][:type]}Profile", "#{convert_type(params[require][:type]).to_s}_id": current_user.id }
        current_user.update_attribute(:type, params[require][:type])
        @profile.update(value)
        redirect_to root_path, flash: { success: I18n.t('update.success') }
      rescue
        flash.now[:alert] = I18n.t('update.failed')
        render :set_account
      end
    end
  end


  private

  def set_buyer
    @profile = current_user.profile if current_user.profile.present?
  end

  def buyer_params
    model = if current_user.buyer?
              :buyer
            elsif current_user.supplier?
              :supplier
            elsif current_user.is_a?(Admin)
              :admin
            else
              :buyer_supplier
            end

    params.require(model).permit(User::PARAMS_ATTRIBUTES)
  end

  def convert_type(type)
    case type
    when 'Buyer'
      require = :buyer
    when 'Supplier'
      require = :supplier
    else
      require = :buyer_supplier
    end
  end

  def clear_session
    session.delete(:register_errors_for_new_user)
    session.delete(:register_errors_for_new_password)
  end
end
