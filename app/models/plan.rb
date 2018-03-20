class Plan < ActiveRecord::Base

	has_many :plan_coupons
	has_many :coupons, :through => :plan_coupons
	has_many :subscriptions, dependent: :destroy
	has_many :students, :through => :subscriptions
	has_one :roster

	validates_presence_of :start_date

	INTERVALS = {
		:week => "Weeks",
		:month => "Months",
		:year => "Years"
	}

	def update_plan_subscriptions
		self.subscriptions.each do |s|
			customer = Stripe::Customer.retrieve("#{s.student.stripe_customer}")
			subscription = customer.subscriptions.retrieve("#{s.stripe_subscription}")
			subscription.prorate = false
			subscription.trial_end = self.trial_end
			subscription.save
		end
	end

	def active_coupon
		plan_coupons.where("tuition_date >= ?", Date.today).first
	end

	def amount_with_coupon
		the_amount = self.amount
		the_amount -= self.active_coupon.coupon.amount_off if self.active_coupon
		the_amount
	end

	def next_billing_date
		next_date = self.start_date.to_time.to_i
		unless self.start_date == Date.today
			int = self.interval
			breaktime = Time.now.at_beginning_of_day.to_i

			if !self.interval_count.nil?
				cnt = self.interval_count
			else
				cnt = 1
			end

			if int == "week"
				while breaktime > next_date do
					next_date += cnt.weeks	
				end
			elsif int == "month"
				while breaktime > next_date do
					next_date += cnt.months
				end
			elsif int == "year"
				while breaktime > next_date do
					next_date += cnt.years
				end
			end
		end
		DateTime.strptime(next_date.to_s,'%s') #=> 2014-03-28 00:00:00 -0600 
	end

	def humanize_next_billing_date
		humanized = ""
		humanized += "today, " if self.next_billing_date == Date.today.to_time
		humanized += "#{ self.next_billing_date.strftime("%B %d, %Y") }"
		humanized #=> "March 28, 2014"
	end
	
	def trial_end
		self.next_billing_date == Date.today.to_time ? "now" : next_billing_date.to_time.to_i
	end

	def name_with_price_and_interval
		"#{name} - $#{amount} #{interval}ly (begins #{ humanize_next_billing_date })"
	end

	
	
end
