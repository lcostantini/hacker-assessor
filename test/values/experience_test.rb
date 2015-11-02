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

  test 'difference' do
    assert_equal 1, exp(3).difference(exp(2))
    assert_equal 2, exp(4) - exp(2)
  end

  def exp level=1, skill=skills(:tdd)
    Experience.new skill, level
  end

end
