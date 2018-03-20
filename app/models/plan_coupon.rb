class PlanCoupon < ActiveRecord::Base
  belongs_to :plan
  belongs_to :coupon
end
