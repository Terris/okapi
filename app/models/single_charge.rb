class SingleCharge < ActiveRecord::Base

  validates :amount, presence: true, length: { maximum: 16 }

	def send_single_charge_receipt_email
		if SingleChargeMailer.single_charge_receipt( self ).deliver
      #self.update_attributes(receipt_sent: true)
    end
		#AdminMailer.single_payment_succeeded( self ).deliver
	end

end
