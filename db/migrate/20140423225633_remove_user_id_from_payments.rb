class RemoveUserIdFromPayments < ActiveRecord::Migration
  def change
    remove_reference :payments, :user, index: true
  end
end
