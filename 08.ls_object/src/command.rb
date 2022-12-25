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

    if @option_l
      total_blocks = ls_files.sum(&:blocks)
      puts "total #{total_blocks}"
      puts list_details(ls_files)
    else
      list_names(ls_files).each do |name_row|
        puts name_row.join
      end
    end
  end

  private

  def extract_ls_files
    ls_files = Dir.glob('*', File::FNM_DOTMATCH).filter_map do |name|
      next if !@option_a && name.start_with?('.')

      LsFile.new(name)
    end

    @option_r ? ls_files.reverse : ls_files
  end

  def list_details(ls_files)
    max_prop_lengths = {
      hard_link: detect_max_prop_length(ls_files, &:hard_link),
      user_name: detect_max_prop_length(ls_files, &:user_name),
      group_name: detect_max_prop_length(ls_files, &:group_name),
      size: detect_max_prop_length(ls_files, &:size)
    }

    ls_files.map do |ls_file|
      format_detail(ls_file, max_prop_lengths)
    end
  end

  def format_detail(ls_file, max_prop_lengths)
    symbolic_mode = ls_file.symbolic_mode
    hard_link = ls_file.hard_link.to_s.rjust(max_prop_lengths[:hard_link])
    user_name = ls_file.user_name.ljust(max_prop_lengths[:user_name])
    group_name = ls_file.group_name.ljust(max_prop_lengths[:group_name])
    size = ls_file.size.to_s.rjust(max_prop_lengths[:size])
    updated_time = ls_file.updated_time.strftime('%m %d %R')
    name = ls_file.name

    "#{symbolic_mode}  #{hard_link} #{user_name}  #{group_name}  #{size} #{updated_time} #{name}"
  end

  def list_names(ls_files)
    formated_names = format_names(ls_files)

    row_count = (formated_names.size / COLUMN_COUNT.to_f).ceil
    formated_name_rows = formated_names.each_slice(row_count)
    filled_formated_name_rows = formated_name_rows.map do |formated_name_row|
      fill_in_row(formated_name_row, row_count)
    end

    filled_formated_name_rows.transpose
  end

  def format_names(ls_files)
    max_name_length = detect_max_prop_length(ls_files, &:name)
    ls_files.map do |ls_file|
      ls_file.name.ljust(max_name_length + 1)
    end
  end

  def fill_in_row(row, row_count)
    row << '' while row_full?(row, row_count)
    row
  end

  def row_full?(row, row_count)
    row.size < row_count
  end

  def detect_max_prop_length(ls_files)
    max_ls_file = ls_files.max_by do |ls_file|
      yield ls_file
      prop = yield ls_file
      prop.to_s.length
    end

    max_prop = yield max_ls_file
    max_prop.to_s.length
  end
end
