class AddColumnsLinkCalendars < ActiveRecord::Migration[5.2]
  def change
    add_column :user_calendars, :url, :string 
  end
end
