class AddStripeCustomerToStudents < ActiveRecord::Migration
  def change
    add_column :students, :stripe_customer, :string
  end
end
