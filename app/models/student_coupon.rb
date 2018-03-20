class StudentCoupon < ActiveRecord::Base
  belongs_to :student
  belongs_to :coupon
end
