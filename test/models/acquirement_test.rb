require 'test_helper'

class AcquirementTest < ActiveSupport::TestCase
  test 'use experience levels' do
    assert_equal 'beginner', acquirements(:jorge_tdd).experience.level
  end
end
