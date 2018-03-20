class SubscriptionMailer < ActionMailer::Base

	default from: "Okapi <foo@example.com>"
	layout 'mailer'

	def student_subscribed(student, subscription)
		@student = student
		@subscription = subscription
		@plan = @subscription.plan
		mail to: student.email, :subject => "Automatic Payments through Okapi"
	end

	def student_unsubscribed(student, subscription)
		@student = student
		@subscription = subscription
		@plan = @subscription.plan
		mail to: student.email, :subject => "Automatic Payments Cancelled"
	end

	def payment_failed(student, subscription)
		@student = student
		@subscription = subscription
		@plan = @subscription.plan
		mail to: student.email, :subject => "Okapi: Your Payment Failed"
	end

	def tuition_notification( student, subscription )
		@student = student
		@subscription = subscription
		@plan = @subscription.plan
		mail to: student.email, :subject => "Okapi: Tuition Reminder"
	end

end
