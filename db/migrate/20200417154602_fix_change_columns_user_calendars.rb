class FixChangeColumnsUserCalendars < ActiveRecord::Migration[5.2]
  def change
    change_column :user_calendars, :type, :string, after: :title
    change_column :user_calendars, :type, :string, limit: 50
    change_column :user_calendars, :url, :string, after: :type
  end
end
