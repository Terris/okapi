class AddStripeCouponToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :stripe_coupon, :string
  end
end
