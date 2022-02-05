#!/usr/bin/env ruby

# frozen_string_literal: true

score = []
args = ARGV.shift.split(',')
p args
args.each do |arg|
  if arg == 'X'
    score.push(10)
    score.push(0) if score.size < 18
  else
    score.push(arg.to_i)
  end
end

p score
sum = 0
flame = [1, 2, 3, 4, 5, 6, 7, 8, 9]

flame.each do |f|
  first_score = score.shift
  second_score = score.shift

  if first_score == 10
    if score[0] == 10 && f != 9
      sum += first_score + score[0] + score[2]
      next
    end

    sum += first_score + score[0] + score[1]
    next
  end

  if first_score + second_score == 10
    sum += first_score + second_score + score[0]
    next
  end

  sum += first_score + second_score
end

p score
sum += score.sum

p sum
