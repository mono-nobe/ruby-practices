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
    all_pins? ? MAX_PIN_COUNTS_BY_FRAME : @mark.to_i
  end
end
