require 'test_helper'

class HackerFlowsTest < ActionDispatch::IntegrationTest

  test "jorge see the list of required skills to reach his next seniority" do
    login :jorge

    within 'tbody tr', text: 'tdd' do
      assert has_content? 'played'
      assert has_content? 'tried'
    end

    click_link 'LOGOUT'
  end

  def login hacker
    visit root_path
    fill_in :email, with: hackers(hacker).email
    fill_in :password, with: hackers(hacker).name
    click_button 'Sign in'
    assert page.has_content? "Successfully logged in"
  end

end
