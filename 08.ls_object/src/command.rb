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
      puts format_details(ls_files)
    else
      format_names(ls_files).each do |name_row|
        puts name_row.join
      end
    end
  end

  private

  def extract_ls_files
    Dir.glob('*', File::FNM_DOTMATCH).map do |name|
      next if !@option_a && name.start_with?('.')

      LsFile.new(name)
    end.compact
  end

  def format_detail(ls_file, hard_link_length, user_name_length, group_name_length, size_length)
    symbolic_mode = ls_file.symbolic_mode
    hard_link = ls_file.hard_link.to_s.rjust(hard_link_length)
    user_name = ls_file.user_name.ljust(user_name_length)
    group_name = ls_file.group_name.ljust(group_name_length)
    size = ls_file.size.to_s.rjust(size_length)
    updated_time = ls_file.updated_time
    name = ls_file.name

    "#{symbolic_mode}  #{hard_link} #{user_name}  #{group_name}  #{size} #{updated_time} #{name}"
  end

  def format_details(ls_files)
    ls_files.each_with_object([]) do |ls_file, details|
      details << format_detail(
        ls_file,
        calc_prop_max_length(ls_files, 'hard_link'),
        calc_prop_max_length(ls_files, 'user_name'),
        calc_prop_max_length(ls_files, 'group_name'),
        calc_prop_max_length(ls_files, 'size')
      )
    end
  end

  def format_names(ls_files)
    name_max_length = calc_prop_max_length(ls_files, 'name')
    names = ls_files.map do |ls_file|
      ls_file.name.ljust(name_max_length + 1)
    end

    row_count = (names.size / COLUMN_COUNT.to_f).ceil
    names.each_slice(row_count).map do |name_row|
      name_row << nil while name_row.size < row_count
      name_row
    end.transpose
  end

  def calc_prop_max_length(ls_files, prop_name)
    ls_files.map do |ls_file|
      ls_file.send(prop_name).to_s
    end.max_by(&:length).length
  end
end
