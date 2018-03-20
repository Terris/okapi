class HookMailer < ActionMailer::Base

	default from: "Okapi <foo@example.com>"
	layout 'mailer'

	def hook_info(event)
		@event = event
		mail to: "foo@example.com", :subject => "Hook info from Okapi"
	end

end
