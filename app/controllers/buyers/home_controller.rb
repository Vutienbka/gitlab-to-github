class Buyers::HomeController < Buyers::BaseController
  before_action :redirect_to_profile

  def index
  end
end
