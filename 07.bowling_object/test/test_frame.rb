# frozen_string_literal: true

require 'test/unit'
require_relative '../src/frame'
require_relative '../src/shot'

class TestCaseFrame < Test::Unit::TestCase
  test '1回目3本、2回目5本倒した時のスコア' do
    first_shot = Shot.new(3)
    second_shot = Shot.new(5)
    frame = Frame.new([first_shot, second_shot])
    assert_equal 8, frame.calc_score_without_bonus
  end

  test 'スペアである' do
    first_shot = Shot.new(4)
    second_shot = Shot.new(6)
    frame = Frame.new([first_shot, second_shot])
    assert frame.spare?
  end

  test 'スペアではない' do
    first_shot = Shot.new(1)
    second_shot = Shot.new(2)
    frame = Frame.new([first_shot, second_shot])
    refute frame.spare?
  end

  test 'スペアではない(1球目で10本倒す)' do
    first_shot = Shot.new('X')
    frame = Frame.new([first_shot])
    refute frame.spare?
  end

  test 'ストライクである' do
    first_shot = Shot.new('X')
    frame = Frame.new([first_shot])
    assert frame.strike?
  end

  test 'ストライクではない' do
    first_shot = Shot.new(3)
    second_shot = Shot.new(3)
    frame = Frame.new([first_shot, second_shot])
    refute frame.strike?
  end
end
