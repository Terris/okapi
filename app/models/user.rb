class User < ActiveRecord::Base
	
	has_one :student
	
	attr_accessor :updating_password
	
	before_save { self.email = email.downcase }
	before_save :update_student
	before_create :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, on: :create
	validates :password, length: { minimum: 6 }, on: :update, allow_blank: true

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def is_admin?
		admin == true
	end

	def send_password_reset
		create_password_reset_token
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def update_student
		if !self.student
			student = Student.find_by email: self.email
			student.update_attributes(:user_id => self.id)
		else
			student = Student.find_by_user_id( self.id )
			unless student.email == self.email
				student.update_attributes(:email => self.email )
			end 
		end
	end
	
	def deactivate
		self.update(deactivated: true)
	end

	def activate
		self.update(deactivated: false)
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

		def create_password_reset_token
			self.password_reset_token = User.encrypt(User.new_remember_token)
		end
end
