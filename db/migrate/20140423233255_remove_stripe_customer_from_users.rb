class RemoveStripeCustomerFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_customer, :string
  end
end
