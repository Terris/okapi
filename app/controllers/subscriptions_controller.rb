class SubscriptionsController < ApplicationController

  before_action :signed_in_user
  before_action :correct_user
  before_action :set_student
  before_action :set_subscription, except:  [ :index, :new, :create ]

  def new
    @subscription = @student.subscriptions.build
  end

  def create

    @subscription = @student.subscriptions.new(subscription_params)
    @plan = Plan.find_by_id(params[:subscription][:plan_id])

    # Retrieve Stripe Customer and update card (source)
    customer = Stripe::Customer.retrieve( @student.stripe_customer )
    customer.source = params[:stripeToken]
    customer.save

    # Build subscription options
    subscription_options = {
      :plan => "#{@plan.id}",
      :trial_end => @plan.trial_end
    }
    subscription_options[:coupon => "#{@plan.active_coupon.coupon.stripe_coupon}"] if @plan.active_coupon

    # Add subscription to customer
    subscription = customer.subscriptions.create( subscription_options )

    # Update subscription with customer data
    @subscription.stripe_subscription = subscription.id
    @subscription.last_four = customer.sources.data.first.last4
    @subscription.invoice_status = "pending"

    # Try to save subscription
    if @subscription.save
      flash[:success] = "Subscription created."
    else
      render "new"
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_student_subscription_path(@student)

  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to new_student_subscription_path(@student)
  end

  def edit
  end

  def update

    token = params[:stripeToken]
    customer = Stripe::Customer.retrieve( @student.stripe_customer )
    customer.card = token

    if customer.save
      flash[:success] = "Card updated."
      @subscription.update_attributes( :last_four => customer.sources.data.first.last4 )
    else
      render "edit"
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to edit_student_subscription_path(@student, @subscription)

  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to edit_student_subscription_path(@student, @subscription)
  end

  def destroy
    @subscription.delete_stripe_subscription
    @subscription.update_attributes(:invoice_status => "pending cancel")
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to student_path( @subscription.student )
  end

  private

    def subscription_params
      draw_params = {
        :student_id => params[:student_id],
        :plan_id => params[:subscription][:plan_id]
      }
      draw_params
    end

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def set_student
      @student = Student.find(params[:student_id])
    end

    def correct_user
			unless current_user.is_admin? || current_user?( Student.find(params[:student_id]).user )
				redirect_to root_path, notice: "You do not have access to that page."
			end
		end

end
