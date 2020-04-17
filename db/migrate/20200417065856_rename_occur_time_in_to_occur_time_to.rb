class RenameOccurTimeInToOccurTimeTo < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_calendars, :occur_time_in, :occur_time_to
  end
end
