# frozen_string_literal: true

require_relative './shot'

class Frame
  MAX_PIN_COUNTS_BY_FRAME = 10

  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def calc_score(leftover_frames)
    frame_score = calc_score_without_bonus
    frame_score += calc_bonus_score(leftover_frames) unless leftover_frames.size == 1

    frame_score
  end

  protected

  def calc_score_without_bonus
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].all_pins?
  end

  def spare?
    !strike? && @shots[0..1].sum(&:score) == MAX_PIN_COUNTS_BY_FRAME
  end

  private

  def calc_bonus_score(leftover_frames)
    if strike?
      calc_strike_bonus_score(leftover_frames)
    elsif spare?
      leftover_frames[1].shots[0].score
    else
      0
    end
  end

  def calc_strike_bonus_score(leftover_frames)
    if leftover_frames.size == 2
      calc_last_strike_bonus_score(leftover_frames.last)
    elsif leftover_frames[1].strike?
      leftover_frames[1].calc_score_without_bonus + leftover_frames[2].shots[0].score
    else
      leftover_frames[1].calc_score_without_bonus
    end
  end

  def calc_last_strike_bonus_score(last_frames)
    last_frames.shots[0].score + last_frames.shots[1].score
  end
end
