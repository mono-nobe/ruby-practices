# frozen_string_literal: true

require_relative './frame'

TOTAL_FRAME_COUNTS = 10
SHOT_COUNTS_BY_FRAME = 2

# 全投球結果を元に合計スコアを算出する
class Game
  def initialize(marks)
    @marks = marks.shift.split(',')
    @frames = devide_marks_by_frame.map do |devided_mark_set|
      Frame.new(devided_mark_set[0], devided_mark_set[1], devided_mark_set[2])
    end
  end

  def score
    score = 0

    @frames.each_with_index do |frame, index|
      score += frame.score
      score += bonus_score(@frames[index..]) unless @frames[index..].size == 1
    end

    score
  end

  def bonus_score(frames)
    if frames.first.strike?
      strike_bonus_score(frames)
    elsif frames.first.spare?
      frames[1].first_shot.score
    else
      0
    end
  end

  def strike_bonus_score(frames)
    if frames.size == 2
      last_strike_bonus_score(frames)
    elsif frames[1].strike?
      frames[1].score + frames[2].first_shot.score
    else
      frames[1].score
    end
  end

  def last_strike_bonus_score(frames)
    frames.last.first_shot.score + frames.last.second_shot.score
  end

  def next_frame?(frame)
    return true if first_frame?(frame)

    !last_frame?(frame) && (full_shot?(frame) || strike?(frame))
  end

  def first_frame?(frame)
    frame.size.zero?
  end

  def strike?(frame)
    frame.last.first == 'X'
  end

  def full_shot?(frame)
    frame.last.size == SHOT_COUNTS_BY_FRAME
  end

  def last_frame?(frame)
    frame.size == TOTAL_FRAME_COUNTS
  end

  private

  def devide_marks_by_frame
    sets_of_marks = []
    @marks.each do |mark|
      sets_of_marks << [] if next_frame?(sets_of_marks)
      sets_of_marks.last.push(mark)
    end

    sets_of_marks
  end
end