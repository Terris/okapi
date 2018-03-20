class CouponsController < ApplicationController

	before_action :admin_user?
	before_action :set_coupon, only: [ :show, :destroy, :apply_to_plan, :apply_to_student ]

	def show
		@plans = Plan.all
		@students = Student.order("name ASC")
	end

	def new
		@coupon = Coupon.new()
	end

	def create
		@coupon = Coupon.new(coupon_params)

		amount_off = (@coupon.amount_off * 100).floor

		coupon = Stripe::Coupon.create(
			:amount_off => amount_off,
			:duration => 'once',
			:currency => "usd"
		)

		@coupon.stripe_coupon = coupon.id

		if @coupon.save
			flash[:success] = "Coupon created."
			redirect_to admin_coupons_path
		else
			render "new"
		end
	rescue Stripe::StripeError => e
		flash[:error] = e.message
		redirect_to new_payment_path
	end

	def destroy
		@coupon.destroy
		# Destroy Stripe Coupon
		coupon = Stripe::Coupon.retrieve(@coupon.stripe_coupon)
		coupon.delete
	rescue Stripe::StripeError => e
		flash[:error] = e.message
		redirect_to new_payment_path
	end

	def apply_to_plan
		@plan = Plan.find(params[:plan])
		@coupon.apply_to_plan( params[:plan] )
	end

	def apply_to_student
		@student = Student.find(params[:student])
		@coupon.apply_to_student( params[:student] )
	end

	private

		def coupon_params
			params.require(:coupon).permit(
				:name,
				:amount_off,
				:notes
			)
		end

		def set_coupon
			@coupon = Coupon.find(params[:id])
		end

end
