# frozen_string_literal: true

class Shot
  ALL_PINS_MARK = 'X'
  MAX_PIN_COUNTS_BY_FRAME = 10

  def initialize(mark)
    @mark = mark
  end

  def all_pins?
    @mark == ALL_PINS_MARK
  end

  def score
    return MAX_PIN_COUNTS_BY_FRAME if @mark == ALL_PINS_MARK

    @mark.to_i
  end
end
