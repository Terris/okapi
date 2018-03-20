class PaymentMailer < ActionMailer::Base

	default from: "Okapi <foo@example.com>"
	layout 'mailer'

	def payment_receipt(payment)
		@payment = payment
		@student = payment.student
		mail to: @student.email, :subject => "Okapi: You made a payment!"
	end

end
