#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './place'

class Cmd
  def initialize
    opt = OptionParser.new
    opt.on('-a') { @option_a = true }
    opt.on('-r') { @option_r = true }
    opt.on('-l') { @option_l = true }
    opt.parse!(ARGV)
  end

  def show_option
    puts '### show_option ###'
    puts @option_a ? 'hoge' : 'piyo'
    puts @option_r ? 'hoge' : 'piyo'
    puts @option_l ? 'hoge' : 'piyo'

    dir = Place.new
    dir.test_place
  end
end
