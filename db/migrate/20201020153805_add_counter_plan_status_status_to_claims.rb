class AddCounterPlanStatusStatusToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :counter_plan_status, :int
  end
end
