class SingleChargeController < ApplicationController

	def new
	end

	def create
		@note = params[:note]
		@dollaramount = params[:amount].to_f
		# Stripe amount in cents
		@amount = (@dollaramount * 100).to_i

		customer = Stripe::Customer.create( :email => params[:email] )
		customer.source = params[:stripeToken]
		customer.save

		charge = Stripe::Charge.create(
			:customer => customer.id,
			:amount      => @amount,
			:description => "#{@note}",
			:currency    => 'usd'
		)

		# Create a new app payment
		@single_charge = SingleCharge.new( single_charge_params )

		# Attempt to save the payment
		if @single_charge.save
			flash[:success] = "Your payment is being processed."
		else
			redirect_to new_single_charge_path
		end

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to new_single_charge_path
	rescue Stripe::StripeError => e
	    flash[:error] = e.message
	    redirect_to new_single_charge_path
	end

	private

		def single_charge_params
			draw_params = {
        :email => params[:email],
        :amount => @dollaramount,
				:note => params[:note],
				:stripe_token => params[:stripeToken]
			}
			draw_params
		end

end
