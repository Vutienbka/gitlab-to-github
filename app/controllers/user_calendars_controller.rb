class UserCalendarsController < ApplicationController 

  def prospect_params
    params.require(:prospect).permit(
      :title,
      :occur_date ,
      :content,
      :occur_time_from,
      :occur_time_to,
      :creator, 
      :user_id
    )
  end

  def new 
    @user_calendar = UserCalendar.new
  end 

  def create
    @user_calendar = UserCalendar.new(user_calendar_params)
    if @user_calendar.save
      flash[:notice] = 'event added'
      redirect_to buyers_calendar_index_path
    else
      flash[:error] = 'failed'
      render :new
    end
  end 

  def show
  end 


  private
  def user_calendar_params
    params.require(:user_calendar).permit(
      :title, :occur_date, :content, :occur_time_from, :occur_time_to, :creator, :user_id
      )
  end 
end
