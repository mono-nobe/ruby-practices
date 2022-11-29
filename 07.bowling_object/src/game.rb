# frozen_string_literal: true

require_relative './frame'

TOTAL_FRAME_COUNTS = 10
SHOT_COUNTS_BY_FRAME = 2

# 全投球結果を元に合計スコアを算出する
class Game
  def initialize(marks)
    @marks = marks.shift.split(',')
    @frames = devide_marks_by_frame.map do |set_of_marks_by_frame|
      Frame.new(set_of_marks_by_frame)
    end
  end

  def calc_score
    score = 0

    @frames.each_with_index do |frame, index|
      score += frame.calc_score(@frames[index..])
    end

    score
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

  def next_frame?(sets_of_marks)
    return true if first_frame?(sets_of_marks)

    !last_frame?(sets_of_marks) && (full_shot?(sets_of_marks.last) || strike?(sets_of_marks.last))
  end

  def first_frame?(sets_of_marks)
    sets_of_marks.size.zero?
  end

  def last_frame?(sets_of_marks)
    sets_of_marks.size == TOTAL_FRAME_COUNTS
  end

  def full_shot?(sets_of_marks)
    sets_of_marks.size == SHOT_COUNTS_BY_FRAME
  end

  def strike?(set_of_marks)
    set_of_marks.first == 'X'
  end
end
