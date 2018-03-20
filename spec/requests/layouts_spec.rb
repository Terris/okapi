require 'spec_helper'

describe "Layouts" do

	subject { page }

	describe "Logged out layout" do
		before { visit root_path }
		it { should have_title(full_title("")) }
		it { should have_link("sign in") }
		it { should_not have_link("my account") }
		it { should_not have_link("sign out") }
		it { should_not have_link("admin") }
	end

	describe "Logged in layout" do
		before { signin_without_views }

		it { should have_link("my account") }
		it { should have_link("sign out") }
		it { should_not have_link("sign in") }
		it { should_not have_link("admin") }
	end

	describe "Admin layout" do
		before { signin_without_views( admin: true ) }

		it { should have_link("my account") }
		it { should have_link("admin") }
		it { should have_link("sign out") }
		it { should_not have_link("sign in") }
	end

end