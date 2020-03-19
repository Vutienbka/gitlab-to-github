class Buyers::BaseController < ActionController::Base
  include ProfileSetting
  before_action :authenticate_user!
  layout "application"
end
