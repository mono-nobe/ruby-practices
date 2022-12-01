# frozen_string_literal: true

ALL_PINS_MARK = 'X'

class Shot
  def initialize(mark)
    @mark = mark
  end

  def all_pins?
    @mark == ALL_PINS_MARK
  end

  def score
    return 10 if @mark == ALL_PINS_MARK

    @mark.to_i
  end
end
