class Subscription < ActiveRecord::Base

	attr_accessor :stripe_token

	belongs_to :student
	belongs_to :plan
	has_many :payments

	def active_coupon
		self.plan.active_coupon
	end

	def delete_stripe_subscription
		customer = Stripe::Customer.retrieve("#{self.student.stripe_customer}")
		customer.subscriptions.retrieve("#{self.stripe_subscription}").delete()
	end

	# Stripe

	def stripe_subscription_created
		self.send_subscription_created_email
	end

	def stripe_subscription_canceled
		self.send_subscription_canceled_email
		self.destroy
	end

	def stripe_invoice_payment_succeeded(invoice)

		self.update_attributes(:invoice_status => "current")

		unless invoice.total == 0
			amount = invoice.total / 100
      charge = invoice.charge
			payment = self.payments.new( student_id: self.student_id, amount: amount, subscription_id: self.id, stripe_charge: charge )
			payment.save
			payment.payment_succeeded
		end

	end

	def stripe_invoice_payment_failed
		self.update_attributes(:invoice_status => "pending: payment failed")
		self.send_payment_failed_email
	end

	# Mailers

	def send_subscription_created_email
		student = Student.find_by_id( self.student_id )
		# SubscriptionMailer#student_subscribed( student, subscription )
		SubscriptionMailer.student_subscribed( student, self ).deliver
		AdminMailer.student_subscribed(student, self).deliver
	end

	def send_subscription_canceled_email
		student = Student.find_by_id( self.student_id )
		# SubscriptionMailer#student_subscribed( student, subscription )
		SubscriptionMailer.student_unsubscribed( student, self ).deliver
		AdminMailer.student_unsubscribed( student, self ).deliver
	end

	def send_payment_failed_email
		student = Student.find_by_id( self.student_id )
		# SubscriptionMailer#payment_failed( student, subscription )
		SubscriptionMailer.payment_failed( student, self ).deliver
		AdminMailer.payment_failed( student, self ).deliver
	end

	def send_tuition_notification
		student = Student.find_by_id( self.student_id )
		# SubscriptionMailer#tuition_notification( student, subscription )
		SubscriptionMailer.tuition_notification( student, self ).deliver
	end

end
