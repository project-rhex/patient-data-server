require 'test_helper'
require 'Notification'
include Devise::TestHelpers

class NotificationEventTest < ActionController::TestCase


  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    @notify_config = FactoryGirl.create(:notify_config)
  end


  test "event_process" do
    assert_not_nil @notify_config, "Notify config is null!"

    NotifyEvent.process("gganley@mitre.org", :record_update)
    notifications = Notification.all.to_a
    assert_not_nil notifications, "Notifications is null !"
    assert_equal notifications.count, 1, "notifications not populated correctly"
  end


end

