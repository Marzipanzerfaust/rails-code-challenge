ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  include Devise::Test::IntegrationHelpers

  def assert_not_authorized
    assert_text "You are not authorized to perform this action."
  end

  def click_link_for(name, string)
    find(:xpath, "//tr/td[text()='#{name}']/ancestor::tr/td/a[text()='#{string}']").click
  end
end
