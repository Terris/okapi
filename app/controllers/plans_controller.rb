class PlansController < ApplicationController

  before_action :admin_user?

	def new
		@plan = Plan.new
	end

	def create
		@plan = Plan.new(plan_attributes)

		if @plan.save
			# Create Stripe Plan
			# convert amount to cents
			@stripeamount = @plan.amount.to_i * 100
			Stripe::Plan.create(
				:amount => @stripeamount,
				:interval => @plan.interval,
				:interval_count => @plan.interval_count,
				:name => @plan.name,
				:currency => 'usd',
				:id => @plan.id
			)

			flash[:success] = "Plan created."
			redirect_to admin_plans_path
		else
			render "new"
		end

	rescue Stripe::StripeError => e
	    flash[:error] = e.message
	    redirect_to new_plan_path
	end

	def edit
		@plan = Plan.find(params[:id])
	end

	def update
		@plan = Plan.find(params[:id])

		if @plan.update_attributes(plan_attributes)

			# Update Stripe plan
			p = Stripe::Plan.retrieve( "#{@plan.id}" )
			p.name = @plan.name
			p.save

			# Update plan subscriptions
			@plan.update_plan_subscriptions

			flash[:success] = "Plan updated."
			redirect_to admin_plans_path
		else
			render "edit"
		end
	rescue Stripe::StripeError => e
	    flash[:error] = e.message
	    redirect_to edit_plan_path(@plan)
	end

	def destroy
		@plan = Plan.find(params[:id]).destroy
		# Delete stripe plan
		p = Stripe::Plan.retrieve( "#{@plan.id}" )
		p.delete
	end

	private

		def plan_attributes
			params.require(:plan).permit(
				:name,
				:amount,
				:interval,
				:interval_count,
				:start_date
			)
		end

end
