class Buyers::BaseController < ApplicationController
  include ProfileSetting
  before_action :authenticate_user!
  layout "application"
end
