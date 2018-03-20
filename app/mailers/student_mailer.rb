class StudentMailer < ActionMailer::Base

	default from: "Okapi <foo@example.com>"
	layout 'mailer'

	def signup_invite(student)
		@student = student
		mail to: student.email, :subject => "Invite to Okapi"
	end

end
