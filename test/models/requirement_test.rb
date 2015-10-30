require 'test_helper'

class RequirementTest < ActiveSupport::TestCase
  test 'use experience levels' do
    assert_equal 'competent', requirements(:senior_js_tdd).experience.level
  end
end
