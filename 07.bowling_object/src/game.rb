# frozen_string_literal: true

require_relative './frame'

# Gameクラスは各フレームのスコアを保持するオブジェクト
class Game
  attr_reader :frames

  def initialize(marks)
    @marks = marks
    @frames = Game.divide_marks_by_frame(compensated_marks).map do |divided_marks|
      Frame.new(divided_marks[0], divided_marks[1], divided_marks[2])
    end
  end

  def self.divide_marks_by_frame(marks)
    divided_marks = []
    marks.each_slice(2) do |first_mark, second_mark|
      divided_marks.push([first_mark, second_mark])
      break if second_mark.nil?
    end

    # 最後の投球が3回の場合は1つにまとめる
    unless (marks.size % 2).zero?
      last_mark = divided_marks.pop
      divided_marks.last(1)[0].concat(last_mark.compact)
    end

    divided_marks
  end

  def compensated_marks
    compensated_marks = []
    @marks.each do |mark|
      compensated_marks.push(mark)
      compensated_marks.push(0) if mark == 'X'
    end

    compensated_marks
  end

  def score
    total = 0
  end
end
