class AddStripeSubscriptionToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription, :string
  end
end
