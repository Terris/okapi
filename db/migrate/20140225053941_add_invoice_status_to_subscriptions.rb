class AddInvoiceStatusToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :invoice_status, :string
  end
end
