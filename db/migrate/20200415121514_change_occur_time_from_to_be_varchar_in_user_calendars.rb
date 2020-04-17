class ChangeOccurTimeFromToBeVarcharInUserCalendars < ActiveRecord::Migration[5.2]
  def change
    change_column :user_calendars, :occur_time_from, :string, limit:5
    rename_column :user_calendars, :occur_time_to, :occur_time_in
  end
end
