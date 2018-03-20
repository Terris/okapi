class CreatePlanCoupons < ActiveRecord::Migration
  def change
    create_table :plan_coupons do |t|
      t.references :plan, index: true
      t.references :coupon, index: true
      t.date :tuition_date

      t.timestamps
    end
  end
end
