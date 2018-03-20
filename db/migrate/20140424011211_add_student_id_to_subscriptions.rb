class AddStudentIdToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :student, index: true
  end
end
