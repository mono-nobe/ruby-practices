# frozen_string_literal: true

# 倒れたピンの本数を返す
class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if @mark == 'X'

    @mark.to_i
  end
end
