class UserMailer < ActionMailer::Base

	default from: "Okapi <test@example.com>"
	layout 'mailer'

	def password_reset(user)
		@user = user
		mail to: user.email, :subject => "Password Reset from Okapi"
	end
end
