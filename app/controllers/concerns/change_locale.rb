module ChangeLocale
  extend ActiveSupport::Concern
  def set_locale
    I18n.locale = :en
  end

  def set_default_locale
    I18n.locale = :ja
  end
end
