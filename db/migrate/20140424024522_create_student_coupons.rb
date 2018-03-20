class CreateStudentCoupons < ActiveRecord::Migration
  def change
    create_table :student_coupons do |t|
      t.references :student, index: true
      t.references :coupon, index: true

      t.timestamps
    end
  end
end
