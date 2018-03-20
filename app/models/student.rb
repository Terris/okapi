class Student < ActiveRecord::Base
	
	belongs_to :user

	has_many :payments
	has_many :subscriptions
	has_many :plans, :through => :subscriptions
	has_many :enrollments, dependent: :destroy
	has_many :rosters, through: :enrollments
	has_many :student_coupons
	has_many :coupons, :through => :student_coupons

	before_create { self.invites_sent = 0 }
	before_create :create_invite_token
	before_save { self.email = email.downcase }
	after_save :update_user
	after_save :update_stripe_customer

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates_presence_of :name
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	scope :visible, -> { where("visible = ?", true ) }

	def send_invite_email
		StudentMailer.signup_invite(self).deliver
		invites = self.invites_sent + 1
		self.update_attributes(:invites_sent => invites)
	end

	def Student.new_invite_token
		SecureRandom.urlsafe_base64
	end

	def Student.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def available_plans
		invalid_subscriptions = []
		self.subscriptions.each do |s|
			invalid_subscriptions << s.plan_id
		end
		return Plan.where.not(id: invalid_subscriptions)
	end

	def update_user
		unless !self.user
			user = User.find( self.user_id )
			unless user.email == self.email
				user.update_attributes(:email => self.email )
			end
		end
	end

	def update_stripe_customer		
		if self.stripe_customer == nil
			customer = Stripe::Customer.create(
				:email => "#{self.email}"
			)
			self.update(stripe_customer: customer.id)
		else
			customer = Stripe::Customer.retrieve(self.stripe_customer)
			customer.email = "#{self.email}"
			customer.save
		end
	end

	private

		def create_invite_token
			self.invite_token = Student.encrypt(Student.new_invite_token)
		end

end
