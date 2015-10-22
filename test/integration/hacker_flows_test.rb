require 'test_helper'

class HackerFlowsTest < ActionDispatch::IntegrationTest

  test "login" do
    login :jorge
  end

  def login hacker
    visit root_path
    fill_in :email, with: hackers(hacker).email
    fill_in :password, with: hackers(hacker).name
    click_button 'Sign in'
    assert page.has_content? "Successfully logged in"
  end

end
