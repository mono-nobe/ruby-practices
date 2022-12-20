#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './equipment'

class Command
  COLUMN_COUNT = 3

  def initialize
    opt = OptionParser.new
    opt.on('-a') { @option_a = true }
    opt.on('-r') { @option_r = true }
    opt.on('-l') { @option_l = true }
    opt.parse!(ARGV)

    @equipments = Dir.glob('*', File::FNM_DOTMATCH).map do |name|
      Equipment.new(name)
    end
  end

  def show_files
    target_equipments = @option_a ? @equipments : extract_non_hidden_equipents
    target_equipments.reverse! if @option_r

    if @option_l
      total_blocks = target_equipments.sum(&:blocks)
      puts "total #{total_blocks}"
      puts format_details(target_equipments)
    else
      format_names(target_equipments).each do |name_row|
        puts name_row.join
      end
    end
  end

  private

  def extract_non_hidden_equipents
    @equipments.each_with_object([]) do |equipment, hidden_equipments|
      hidden_equipments << equipment unless equipment.name.start_with?('.')
    end
  end

  def format_details(files)
    files.each_with_object([]) do |file, details|
      details << file.format_detail(
        file,
        calc_prop_max_length(files, 'hard_link'),
        calc_prop_max_length(files, 'user_name'),
        calc_prop_max_length(files, 'group_name'),
        calc_prop_max_length(files, 'size')
      )
    end
  end

  def format_names(files)
    name_max_length = calc_prop_max_length(files, 'name')
    names = files.map do |file|
      file.name.ljust(name_max_length + 1)
    end

    row_count = (names.size / COLUMN_COUNT.to_f).ceil
    names.each_slice(row_count).map do |name_row|
      name_row << nil while name_row.size < row_count
      name_row
    end.transpose
  end

  def calc_prop_max_length(files, prop_name)
    files.map do |file|
      file.send(prop_name).to_s
    end.max_by(&:length).length
  end
end
