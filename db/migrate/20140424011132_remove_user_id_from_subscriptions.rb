class RemoveUserIdFromSubscriptions < ActiveRecord::Migration
  def change
    remove_reference :subscriptions, :user, index: true
  end
end
