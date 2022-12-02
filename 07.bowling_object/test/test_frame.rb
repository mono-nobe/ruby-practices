# frozen_string_literal: true

require 'test/unit'
require_relative '../src/frame'
require_relative '../src/shot'

class TestCaseFrame < Test::Unit::TestCase
  test '8フレーム目(9フレームではない)でストライクだった時のスコア' do
    first_shot_for_eight_frame = Shot.new('X')
    first_shot_for_nine_frame = Shot.new(4)
    second_shot_for_nine_frame = Shot.new(5)
    first_shot_for_ten_frame = Shot.new(1)
    second_shot_for_ten_frame = Shot.new(2)
    third_shot_for_ten_frame = Shot.new(3)

    target_frame = Frame.new([first_shot_for_eight_frame])
    leftover_frames =
      [
        target_frame,
        Frame.new([first_shot_for_nine_frame, second_shot_for_nine_frame]),
        Frame.new([first_shot_for_ten_frame, second_shot_for_ten_frame, third_shot_for_ten_frame])
      ]

    assert_equal 19, target_frame.calc_score(leftover_frames)
  end

  test '9フレーム目でストライクだった時のスコア' do
    first_shot_for_nine_frame = Shot.new('X')
    first_shot_for_ten_frame = Shot.new(1)
    second_shot_for_ten_frame = Shot.new(2)
    third_shot_for_ten_frame = Shot.new(3)

    target_frame = Frame.new([first_shot_for_nine_frame])
    leftover_frames =
      [
        target_frame,
        Frame.new([first_shot_for_ten_frame, second_shot_for_ten_frame, third_shot_for_ten_frame])
      ]

    assert_equal 13, target_frame.calc_score(leftover_frames)
  end

  test '10フレーム目でストライクだった時のスコア' do
    first_shot_for_ten_frame = Shot.new('X')
    second_shot_for_ten_frame = Shot.new('X')
    third_shot_for_ten_frame = Shot.new('X')

    target_frame = Frame.new([first_shot_for_ten_frame, second_shot_for_ten_frame, third_shot_for_ten_frame])
    leftover_frames = [target_frame]

    assert_equal 30, target_frame.calc_score(leftover_frames)
  end
end
