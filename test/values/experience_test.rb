require 'test_helper'

class ExperienceTest < ActiveSupport::TestCase

  test 'liberal with input' do
    a = Experience.new skills(:tdd), 5
    b = Experience.new skills(:tdd), 'EXPERT'
    c = Experience.new skills(:tdd).id, 5
    d = Experience.new skills(:tdd).id, 'expert'

    assert_equal a, b
    assert_equal a, c
    assert_equal a, d
  end

  test 'no experience' do
    exp = Experience.new skills(:tdd), nil
    assert_equal 'none', exp.level
  end

  test 'comparations' do
    a = Experience.new skills(:tdd), 5
    b = Experience.new skills(:tdd), 6
    assert a < b
  end

  test 'do not compare mismatching experience' do
    a = Experience.new skills(:tdd), 5
    b = Experience.new skills(:javascript), 5
    refute a == b
    assert_raise { a < b }
  end

end
