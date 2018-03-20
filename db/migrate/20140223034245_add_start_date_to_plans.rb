class AddStartDateToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :start_date, :date
  end
end
