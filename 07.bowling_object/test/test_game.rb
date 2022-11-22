# frozen_string_literal: true

require 'test/unit'
require_relative '../src/game'

# Gameクラスのテスト
class TestCaseGame < Test::Unit::TestCase
  # compensate_marksのテスト
  test 'ストライクが存在する' do
    game = Game.new([1, 2, 'X', 3, 4])
    assert_equal [1, 2, 'X', 0, 3, 4], game.compensated_marks
  end

  test 'ストライクが存在しない' do
    game = Game.new([1, 2, 3, 4, 5, 6])
    assert_equal [1, 2, 3, 4, 5, 6], game.compensated_marks
  end

  # self.divide_marks_by_frameのテスト
  test '投球が6回(2+2+2)' do
    divided_marks = Game.divide_marks_by_frame([0, 1, 2, 3, 4, 5])
    assert_equal [[0, 1], [2, 3], [4, 5]], divided_marks
  end

  test '投球が7回(2+2+3)' do
    divided_marks = Game.divide_marks_by_frame([0, 1, 2, 3, 4, 5, 6])
    assert_equal [[0, 1], [2, 3], [4, 5, 6]], divided_marks
  end

  # scoreのテスト
  # test '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5の場合' do
  #   game = Game.new([6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 6, 4, 5])
  #   assert_equal 139, game.marks
  # end
end
