class AddReceiptSentToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :receipt_sent, :boolean
  end
end
