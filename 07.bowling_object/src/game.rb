# frozen_string_literal: true

require_relative './frame'

# Gameクラスは各フレームのスコアを保持するオブジェクト
class Game
  attr_reader :marks, :frames

  def initialize(marks)
    @marks = marks.split(',')
    @frames = devided_marks.map do |mark|
      Frame.new(mark[0], mark[1], mark[2])
    end
  end

  def devided_marks
    devided_marks = []
    marks.each do |mark|
      devided_marks << [] if next_frame?(devided_marks)
      devided_marks.last.push(mark)
    end

    devided_marks
  end

  def score
    score = 0

    @frames.each_with_index do |frame, index|
      score += frame.score
      score += bonus_score(frame, index) unless index == 9
    end

    score
  end

  def bonus_score(frame, index)
    if frame.strike?
      strike_bonus(index)
    elsif frame.spare?
      @frames[index + 1].first_shot.score
    else
      0
    end
  end

  def strike_bonus(index)
    if index == 8
      last_strike_bonus
    elsif @frames[index + 1].strike?
      @frames[index + 1].score + @frames[index + 2].first_shot.score
    else
      @frames[index + 1].score
    end
  end

  def last_strike_bonus
    @frames[9].first_shot.score + @frames[9].second_shot.score
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
    frame.last.size == 2
  end

  def last_frame?(frame)
    frame.size == 10
  end
end
