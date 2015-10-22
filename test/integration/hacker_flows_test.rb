require 'test_helper'

class HackerFlowsTest < ActionDispatch::IntegrationTest

  test "login and display missign skills" do
    login :jorge
    assert has_content? "missing skills"
    within 'li' do
      assert has_content? 'tdd'
      assert has_content? 'Required level: played'
    end
  end

  def login hacker
    visit root_path
    fill_in :email, with: hackers(hacker).email
    fill_in :password, with: hackers(hacker).name
    click_button 'Sign in'
    assert page.has_content? "Successfully logged in"
  end

end
