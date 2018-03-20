class Coupon < ActiveRecord::Base

	has_many :plan_coupons, dependent: :destroy
	has_many :plans, :through => :plan_coupons

	has_many :student_coupons, dependent: :destroy
	has_many :students, :through => :student_coupons

	validates :name, presence: true, length: { maximum: 50 }
	validates_presence_of :amount_off
	validates_presence_of :stripe_coupon

	def apply_to_subscription(subscription)
		student = subscription.student
		unless student.user.nil?
			customer = Stripe::Customer.retrieve(subscription.student.stripe_customer)
			customer.coupon = self.stripe_coupon
			customer.save
		end
	end

	def apply_to_plan(plan)
		# find plan
		plan = Plan.find(plan)

		# apply coupon to each current subscriber of the plan
		plan.subscriptions.each do |s|
			apply_to_subscription(s)
		end

		# create a plan_coupon record
		self.plan_coupons.create( plan_id: plan.id, tuition_date: plan.next_billing_date.strftime("%Y/%m/%d") )
	end

	def apply_to_student(student)
		# find student
		student = Student.find(student)
		unless student.user.nil?
			# apply coupon to customer
			customer = Stripe::Customer.retrieve("#{student.stripe_customer}")
			customer.coupon = self.stripe_coupon
			customer.save
			# create a user_coupon record
			self.student_coupons.create( student_id: student.id )
		end
	end

	def currently_applied_to_plan?(plan_id)
		plan_coupons.where("plan_id = ? AND tuition_date >= ?", plan_id, Date.today).first
	end

	def currently_applied_to_student?(student_id)
		student_coupons.where("student_id = ? AND coupon_used = ?", student_id, false).first
	end

end