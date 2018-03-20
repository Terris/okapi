require 'test_helper'

class SubscriptionMailerTest < ActionMailer::TestCase
  test "user_subscribed" do
    mail = SubscriptionMailer.user_subscribed
    assert_equal "User subscribed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
