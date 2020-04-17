# frozen_string_literal: true

class Buyers::CalendarController < Buyers::BaseController
  before_action :redirect_to_profile

  def index
    @date = Date.current
    show_calendar
    @user_calendars = UserCalendar.where(creator: current_user.id).or(UserCalendar.where(user_id: [current_user.id, 0])).group_by { |event| event.occur_date.to_date }
  end
  ``
  def show_calendar
    @date = params[:start_date]&.to_date || Date.current
    start_date = @date.beginning_of_month
    @user_calendars = UserCalendar.where(creator: current_user.id).or(UserCalendar.where(user_id: [current_user.id, 0])).group_by { |event| event.occur_date.to_date }
  end
end
