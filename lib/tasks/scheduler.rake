desc "This task is called by the Heroku scheduler add-on"
task :tuition_notifications => :environment do
	subscriptions = Subscription.all
	subscriptions.each do |s|
		if Date.parse(s.plan.next_billing_date.to_s) == Date.tomorrow
			s.send_tuition_notification
		end
	end
end