# frozen_string_literal: true

require 'test/unit'
require_relative '../src/frame'

# Frameクラスのテスト
class TestCaseFrame < Test::Unit::TestCase
  # scoreのテスト
  test '1回目3本、2回目5本倒した時のスコア' do
    frame = Frame.new(3, 5)
    assert_equal 8, frame.score
  end

  # spare?のテスト
  test 'スペアである' do
    frame = Frame.new(4, 6)
    assert frame.spare?
  end

  test 'スペアではない' do
    frame = Frame.new(1, 2)
    refute frame.spare?
  end

  test 'スペアではない(1球目で10本倒す)' do
    frame = Frame.new(10, 0)
    refute frame.spare?
  end

  # strike?のテスト
  test 'ストライクである' do
    frame = Frame.new(10, 0)
    assert frame.strike?
  end

  test 'ストライクではない' do
    frame = Frame.new(3, 3)
    refute frame.strike?
  end
end
