include ApplicationHelper

def sign_in(user, options={})
	if options[:no_capybara]
		# Sign in when not using Capybara as well.
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.hash(remember_token))
	else
		visit signin_path
		fill_in "Email",    with: user.email
		fill_in "Password", with: user.password
		click_button "Sign in"
	end
end

def signin_without_views( options={})
	@student = Student.create( name: "Example User", email: "example@user.com" )
	if options[:admin] == true
		@user = User.create( name: @student.name, email: @student.email, password: "foobar", password_confirmation: "foobar", :admin => true )
	else
		@user = User.create( name: @student.name, email: @student.email, password: "foobar", password_confirmation: "foobar" )
	end
	sign_in(@user)
end