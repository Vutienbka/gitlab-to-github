class ChangeColumnsUserCalendars < ActiveRecord::Migration[5.2]
  def change
    change_column :user_calendars, :user_id, :bigint, after: :id
    change_column :user_calendars, :url, :string, after: :creator
  end
end
