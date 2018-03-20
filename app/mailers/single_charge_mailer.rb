class SingleChargeMailer < ActionMailer::Base

	default from: "Okapi <foo@example.com>"
	layout 'mailer'

	def payment_receipt(single_charge)
		@single_charge = single_charge
		mail to: @single_charge.email, :subject => "Okapi: You made a payment!"
	end

end
