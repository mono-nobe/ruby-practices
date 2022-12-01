# frozen_string_literal: true

require 'test/unit'
require_relative '../src/frame'

class TestCaseFrame < Test::Unit::TestCase
  # test '1回目3本、2回目5本倒した時のスコア' do
  #   frame = Frame.new([3, 5])
  #   assert_equal 8, frame.calc_score
  # end

  test 'スペアである' do
    frame = Frame.new([4, 6])
    assert frame.spare?
  end

  test 'スペアではない' do
    frame = Frame.new([1, 2])
    refute frame.spare?
  end

  test 'スペアではない(1球目で10本倒す)' do
    frame = Frame.new([10])
    refute frame.spare?
  end

  test 'ストライクである' do
    frame = Frame.new([10])
    assert frame.strike?
  end

  test 'ストライクではない' do
    frame = Frame.new([3, 3])
    refute frame.strike?
  end
end
