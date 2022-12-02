# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  TOTAL_FRAME_COUNTS = 10
  SHOT_COUNTS_BY_FRAME = 2

  def initialize(marks)
    @marks = marks.split(',')
    @frames = devide_shots_by_frame.map do |shots_by_frame|
      Frame.new(shots_by_frame)
    end
  end

  def calc_score
    @frames.each_with_index.sum do |frame, index|
      frame.calc_score(@frames[index..])
    end
  end

  private

  def devide_shots_by_frame
    shots_by_frame = []
    @marks.each do |mark|
      shots_by_frame << [] if next_frame?(shots_by_frame)
      shots_by_frame.last.push(Shot.new(mark))
    end

    shots_by_frame
  end

  def next_frame?(shots_by_frame)
    return true if first_frame?(shots_by_frame)

    !last_frame?(shots_by_frame) && (full_shot?(shots_by_frame.last) || strike?(shots_by_frame.last))
  end

  def first_frame?(shots_by_frame)
    shots_by_frame.empty?
  end

  def last_frame?(shots_by_frame)
    shots_by_frame.size == TOTAL_FRAME_COUNTS
  end

  def full_shot?(shots_by_frame)
    shots_by_frame.size == SHOT_COUNTS_BY_FRAME
  end

  def strike?(shots_by_frame)
    shots_by_frame[0].all_pins?
  end
end
