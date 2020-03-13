class HomeController < ApplicationController
  def index
    @date = Date.current
  end

  def show_calendar
    @date = params[:start_date]&.to_date || Date.current
    start_date = @date.beginning_of_month
  end
end
