#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './ls_file'

class Command
  COLUMN_COUNT = 3

  def initialize
    opt = OptionParser.new
    opt.on('-a') { @option_a = true }
    opt.on('-r') { @option_r = true }
    opt.on('-l') { @option_l = true }
    opt.parse!(ARGV)
  end

  def show_files
    ls_files = extract_ls_files
    ls_files.reverse! if @option_r

    if @option_l
      total_blocks = ls_files.sum(&:blocks)
      puts "total #{total_blocks}"
      puts box_details(ls_files)
    else
      box_names(ls_files).each do |name_row|
        puts name_row.join
      end
    end
  end

  private

  def extract_ls_files
    Dir.glob('*', File::FNM_DOTMATCH).filter_map do |name|
      next if !@option_a && name.start_with?('.')

      LsFile.new(name)
    end
  end

  def box_details(ls_files)
    hard_links = get_prop_strings(ls_files, 'hard_link')
    user_names = get_prop_strings(ls_files, 'user_name')
    group_names = get_prop_strings(ls_files, 'group_name')
    sizes = get_prop_strings(ls_files, 'size')

    prop_max_lengths = {
      hard_link: calc_prop_max_length(hard_links),
      user_name: calc_prop_max_length(user_names),
      group_name: calc_prop_max_length(group_names),
      size: calc_prop_max_length(sizes)
    }

    ls_files.map do |ls_file|
      format_detail(ls_file, prop_max_lengths)
    end
  end

  def get_prop_strings(ls_files, prop_name)
    ls_files.map do |ls_file|
      ls_file.send(prop_name).to_s
    end
  end

  def format_detail(ls_file, prop_max_lengths)
    symbolic_mode = ls_file.symbolic_mode
    hard_link = ls_file.hard_link.to_s.rjust(prop_max_lengths[:hard_link])
    user_name = ls_file.user_name.ljust(prop_max_lengths[:user_name])
    group_name = ls_file.group_name.ljust(prop_max_lengths[:group_name])
    size = ls_file.size.to_s.rjust(prop_max_lengths[:size])
    updated_time = ls_file.updated_time
    name = ls_file.name

    "#{symbolic_mode}  #{hard_link} #{user_name}  #{group_name}  #{size} #{updated_time} #{name}"
  end

  def box_names(ls_files)
    names = ls_files.map(&:name)
    formated_names = format_names(names)

    row_count = (names.size / COLUMN_COUNT.to_f).ceil
    formated_name_rows = formated_names.each_slice(row_count)
    formated_name_rows.map do |name_row|
      name_row << nil while row_full?(name_row, row_count)
      name_row
    end.transpose
  end

  def format_names(names)
    name_max_length = calc_prop_max_length(names)
    names.map do |name|
      name.ljust(name_max_length + 1)
    end
  end

  def row_full?(row, row_count)
    row.size < row_count
  end

  def calc_prop_max_length(strings)
    strings.max_by(&:length).length
  end
end
