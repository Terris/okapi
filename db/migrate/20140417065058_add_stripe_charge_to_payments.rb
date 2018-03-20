class AddStripeChargeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :stripe_charge, :string
  end
end
