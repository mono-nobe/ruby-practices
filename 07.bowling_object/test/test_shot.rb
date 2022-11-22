# frozen_string_literal: true

require 'test/unit'
require_relative '../src/shot'

# Shotクラスのテスト
class TestCaseShot < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  test '3本倒した時のスコア' do
    shot = Shot.new(3)
    assert_equal 3, shot.score
  end

  test '全て倒した時のスコア' do
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end
end
