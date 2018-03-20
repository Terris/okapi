class Payment < ActiveRecord::Base

	belongs_to :student
	belongs_to :subscription

	validates :amount, presence: true, length: { maximum: 16 }

	#after_save :send_payment_receipt_email

	def payment_succeeded
		self.update(stripe_payment_succeeded: true)
    unless self.receipt_sent
      self.send_payment_receipt_email
    end
	end

	def send_payment_receipt_email
		if PaymentMailer.payment_receipt( self ).deliver
      self.update_attributes(receipt_sent: true)
    end
		#AdminMailer.payment_succeeded( self ).deliver
	end

end
