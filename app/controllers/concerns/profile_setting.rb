module ProfileSetting
  extend ActiveSupport::Concern

  def redirect_to_profile
    return unless current_user.present? && current_user.profile.blank?

    flash[:info] = "プロフィールの入力完了後に案件の閲覧が可能です。"
    # TODO:: Change text
    redirect_to buyers_profiles_path
  end
end
