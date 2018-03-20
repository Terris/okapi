class AddStudentIdToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :student, index: true
  end
end
