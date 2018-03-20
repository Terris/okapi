class AdminMailer < ActionMailer::Base
  default from: "Okapi <foo@example.com>"
  layout 'mailer'

  def payment_succeeded(payment)
    @payment = payment
    @student = payment.student
    mail to: "#{Okapi::Application.config.admin_email}", :subject => "Okapi: Successful Payment"
  end

  def payment_failed(student, subscription)
    @student = student
    @subscription = subscription
    @plan = @subscription.plan
    mail to: "#{Okapi::Application.config.admin_email}", :subject => "Okapi: Payment Failed"
  end

  def student_subscribed(student, subscription)
    @student = student
    @subscription = subscription
    @plan = @subscription.plan
    mail to: "#{Okapi::Application.config.admin_email}", :subject => "Okapi: Student Subscribed"
  end

  def student_unsubscribed(student, subscription)
    @student = student
    @subscription = subscription
    @plan = @subscription.plan
    mail to: "#{Okapi::Application.config.admin_email}", :subject => "Okapi: Student Unsubscribed"
  end

end
