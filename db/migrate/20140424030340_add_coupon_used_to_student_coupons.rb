class AddCouponUsedToStudentCoupons < ActiveRecord::Migration
  def change
    add_column :student_coupons, :coupon_used, :boolean
  end
end
