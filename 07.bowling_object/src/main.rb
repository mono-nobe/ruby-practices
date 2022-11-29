# frozen_string_literal: true

require_relative './game'

def main
  game = Game.new(ARGV)
  puts game.calc_score
end

main
