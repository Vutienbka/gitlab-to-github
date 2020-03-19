class Buyer::HomeController < Buyer::BaseController
  def index
    @date = Date.current
  end

  def show_calendar
    # TODO:: change routes, js, css
    @date = params[:start_date]&.to_date || Date.current
    start_date = @date.beginning_of_month
  end
end
