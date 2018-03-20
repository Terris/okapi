class AddLastFourToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :last_four, :string
  end
end
