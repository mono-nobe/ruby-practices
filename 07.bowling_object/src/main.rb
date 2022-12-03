# frozen_string_literal: true

require_relative './game'

game = Game.new(ARGV.shift)
puts game.calc_score
