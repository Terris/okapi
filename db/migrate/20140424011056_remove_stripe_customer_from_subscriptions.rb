class RemoveStripeCustomerFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :stripe_customer, :string
  end
end
