#!/usr/bin/env ruby

# frozen_string_literal: true

# 1フレーム毎の点数を返す
def points_for_flame(first_score, second_score)
  first_score + second_score
end

# 投げた結果を数値にして返す
def throw_points(scores)
  points = []
  scores.each do |score|
    # ストライクの場合
    if score == 'X'
      points.push(10)
      # 9フレーム目まではストライクの場合[10, 0]とする
      points.push(0) if points.size < 18
    else
      points.push(score.to_i)
    end
  end

  points
end

# ストライクの場合のポイント
def strike_point(points, flame)
  # 次の投球結果がストライクかつ9フレームではない場合
  if points[0] == 10 && flame != 9
    10 + points[0] + points[2]
  else
    10 + points[0] + points[1]
  end
end

throw_resutls = ARGV.shift.split(',')
points = throw_points(throw_resutls)

sum_score = 0
# 9フレームまで同じ処理を繰り返す
flames = [1, 2, 3, 4, 5, 6, 7, 8, 9]

flames.each do |flame|
  first_point = points.shift
  second_point = points.shift

  # ストライクの場合
  if first_point == 10
    sum_score += strike_point(points, flame)
    next
  end

  # スペアの場合
  if points_for_flame(first_point, second_point) == 10
    sum_score += points_for_flame(first_point, second_point) + points[0]
    next
  end

  sum_score += points_for_flame(first_point, second_point)
end

# 10フレームの投球ポイントを加算する
sum_score += points.sum
p sum_score
