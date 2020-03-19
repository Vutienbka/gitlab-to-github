class Buyer::HomeController < Buyer::BaseController
  before_action :authenticate_user!

  def index
  end
end
