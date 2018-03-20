class AdminController < ApplicationController

	before_action :admin_user?

	def index
		@rosters = Roster.order("start_date ASC")
	end

	def students
		@students = Student.visible.order("name ASC").page(params[:student_page])
	end

	def plans
		@plans = Plan.all
	end

	def coupons
		@coupons = Coupon.all
	end

	def users
		@users = User.where("deactivated = ?", false).order("name ASC").page(params[:user_page])
		@deactivatedusers = User.where("deactivated = ?", true).order("name ASC")
	end

	def subscriptions
		@subscriptions = Subscription.order(plan_id: :asc)
	end

	def payments
		@payments = Payment.order("created_at DESC").page params[:payment_page]
	end

	def balances
		balance = Stripe::Balance.retrieve()
		@balance = {
			:available => balance.available.first.amount,
			:pending => balance.pending.first.amount
		}
	end

end
