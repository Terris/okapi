 source 'https://rubygems.org'

ruby "2.2.2"

gem 'rails', '4.0.2'
gem 'pg'
gem 'bcrypt-ruby', '3.1.2'
gem "haml-rails", "~> 0.5.3"
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem 'rails_12factor', group: :production
gem 'unicorn'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'stripe_event'
gem 'kaminari'

group :development do
	gem 'rails_layout'
	gem "letter_opener"
	gem 'rspec-rails', '2.13.1'
end

group :test do
	gem 'selenium-webdriver', '2.35.1'
    gem 'capybara', '2.1.0'
    gem 'spork-rails', '4.0.0'
	gem 'childprocess', '0.3.6'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
