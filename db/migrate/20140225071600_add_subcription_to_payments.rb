class AddSubcriptionToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :subscription, index: true
  end
end
