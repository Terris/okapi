class AddStripePaymentSucceededToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :stripe_payment_succeeded, :boolean
  end
end
