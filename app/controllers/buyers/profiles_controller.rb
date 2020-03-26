class Buyers::ProfilesController < Buyers::BaseController
  before_action :clear_session
  before_action :set_buyer, only: %i[edit update set_account update_account]

  def edit
  end

  def update
    return redirect_to set_account_buyers_profiles_path, flash: { success: I18n.t('update.success') } if @buyer.update(buyer_params)
    
    flash.now[:alert] = I18n.t('update.failed')
    render :edit
  end

  def set_account
  end

  def update_account
    begin
      ActiveRecord::Base.transaction do
        require = convert_type(current_user.type)
        return redirect_to root_path, flash: { success: I18n.t('update.success') } if current_user.type == params[require][:type]

        value = { "#{require.to_s}_id": nil, type: "#{params[require][:type]}Profile", "#{convert_type(params[require][:type]).to_s}_id": current_user.id }
        current_user.update(type: params[require][:type])
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
    @buyer = current_user
    @profile = @buyer.profile if @buyer.present?
    @profile = @buyer.build_profile if @buyer.profile.blank?
  end

  def buyer_params
    return params.require(:buyer).permit(User::PARAMS_ATTRIBUTES) if current_user.buyer?

    return params.require(:supplier).permit(User::PARAMS_ATTRIBUTES) if current_user.supplier?

    params.require(:buyer_supplier).permit(User::PARAMS_ATTRIBUTES)
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