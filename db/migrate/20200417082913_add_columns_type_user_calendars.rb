class AddColumnsTypeUserCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :user_calendars, :type, :string, after: :title
  end
end
