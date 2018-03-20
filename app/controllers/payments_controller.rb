class PaymentsController < ApplicationController

	before_action :correct_user

	def new
	end

	def create
		@student = Student.find(params[:student_id])
		@note = params[:note]
		@dollaramount = params[:amount].to_f
		# Stripe amount in cents
		@amount = (@dollaramount * 100).to_i

		customer = Stripe::Customer.retrieve( @student.stripe_customer )
		customer.source = params[:stripeToken]
		customer.save

		charge = Stripe::Charge.create(
			:customer    => customer.id,
			:amount      => @amount,
			:description => "#{@note}",
			:currency    => 'usd'
		)

		# Create a new app payment
		@payment = Payment.new( payment_params )

		# Save the stripe charge id to app Payment
		@payment.stripe_charge = charge.id

		# Attempt to save the payment
		if @payment.save
			flash[:success] = "Your payment is being processed."
		else
			redirect_to new_student_payment_path(@student)
		end

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to new_student_payment_path(@student)
	rescue Stripe::StripeError => e
	    flash[:error] = e.message
	    redirect_to new_student_payment_path(@student)
	end

	private

		def payment_params
			draw_params = {
				:student_id => @student.id,
				:amount => @dollaramount,
				:note => params[:note],
				:stripe_token => params[:stripeToken]
			}
			draw_params
		end

		def correct_user
			unless current_user.is_admin? || current_user?( Student.find(params[:student_id]).user )
				redirect_to root_path, notice: "You do not have access to that page."
			end
		end

end
