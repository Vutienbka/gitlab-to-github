module ProfileSetting
  extend ActiveSupport::Concern

  def redirect_to_profile
    return unless current_user.profile.blank?

    flash[:info] = "プロフィールの入力完了後に案件の閲覧が可能です。"
    # TODO:: Change text
    redirect_to buyers_profiles_path
  end

  def check_authentication_of_buyer
    return redirect_to root_path, flash: {alert: t('messages.no_authenticated')} unless current_user.buyer?
  end
end
