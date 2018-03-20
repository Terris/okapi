Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# Stripe Event Hooks
StripeEvent.configure do |events|
    
  # CUSTOMER.SUBSCRIPTION

  events.subscribe 'customer.subscription.created' do |event|
    subscription = Subscription.where(stripe_subscription: event.data.object.id).take
    subscription.stripe_subscription_created
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    subscription = Subscription.where(stripe_subscription: event.data.object.id).take  
    subscription.stripe_subscription_canceled
  end

  # INVOICE

  events.subscribe 'invoice.payment_succeeded' do |event|
    invoice = Stripe::Invoice.retrieve(event.data.object.id)
    subscription = Subscription.where(stripe_subscription: event.data.object.lines.data.first.id ).take
    subscription.stripe_invoice_payment_succeeded(invoice)
  end

  events.subscribe 'invoice.payment_failed' do |event|
    subscription = Subscription.where(stripe_subscription: event.data.object.lines.data.first.id ).take
    subscription.stripe_invoice_payment_failed
  end

  # PAYMENT

  events.subscribe 'charge.succeeded' do |event|
    payment = Payment.where(stripe_charge: event.data.object.id).take
    payment.payment_succeeded
  end  

  events.all do |event|
    # Handle all event types - logging, etc.
  end

end