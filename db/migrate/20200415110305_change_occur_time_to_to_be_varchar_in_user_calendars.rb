class ChangeOccurTimeToToBeVarcharInUserCalendars < ActiveRecord::Migration[5.2]
  def change
    change_column :user_calendars, :occur_time_to, :string, limit:5
    
    
  end
end
