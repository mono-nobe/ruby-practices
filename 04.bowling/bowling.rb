#!/usr/bin/env ruby

# frozen_string_literal: true

POINT_SIZE_FOR_NINE_FRAME = 18

def point_for_frame(first_score, second_score)
  first_score + second_score
end

def throw_points(scores)
  points = []
  scores.each do |score|
    if score == 'X'
      points.push(10)
      points.push(0) if points.size < POINT_SIZE_FOR_NINE_FRAME
    else
      points.push(score.to_i)
    end
  end

  points
end

def strike_point(points, frame)
  if points[0] == 10 && frame != 9
    10 + points[0] + points[2]
  else
    10 + points[0] + points[1]
  end
end

def spare_point(frame_point, next_point)
  frame_point + next_point
end

throw_results = ARGV.shift.split(',')
points = throw_points(throw_results)

sum_score = 0
frames = [1, 2, 3, 4, 5, 6, 7, 8, 9]

frames.each do |frame|
  first_point = points.shift
  second_point = points.shift

  if first_point == 10
    sum_score += strike_point(points, frame)
    next
  end

  if point_for_frame(first_point, second_point) == 10
    sum_score += spare_point(point_for_frame(first_point, second_point), points[0])
    next
  end

  sum_score += point_for_frame(first_point, second_point)
end

sum_score += points.sum
p sum_score
