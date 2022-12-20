#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './place'

class Command
  def initialize
    opt = OptionParser.new
    opt.on('-a') { @option_a = true }
    opt.on('-r') { @option_r = true }
    opt.on('-l') { @option_l = true }
    opt.parse!(ARGV)
  end

  def show_files
    place = Place.new

    equipments = @option_a ? place.equipments : place.extract_non_hidden_equipents
    equipments.reverse! if @option_r

    if @option_l
      total_blocks = equipments.sum(&:blocks)
      puts "total #{total_blocks}"
      puts place.format_details(equipments)
    else
      place.format_names(equipments).each do |name_row|
        puts name_row.join
      end
    end
  end
end
