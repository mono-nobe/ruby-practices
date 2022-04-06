#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3

def main
  is_option_all = false
  is_reverse = false

  opt = OptionParser.new
  opt.on('-a') { is_option_all = true }
  opt.on('-r') { is_reverse = true }
  opt.parse!(ARGV)

  file_names = is_option_all ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_file_names = is_reverse ? file_names.reverse : file_names

  max_name_length = sorted_file_names.max_by(&:length).length

  rows = generate_rows(
    ljust_dir_items(max_name_length, sorted_file_names),
    calc_row_count(sorted_file_names.size)
  )

  rows.each { |row| puts row.join }
end

def calc_row_count(dir_items_count)
  (dir_items_count / COLUMN_COUNT.to_f).ceil
end

def ljust_dir_items(max_name_length, dir_items)
  dir_items.map do |dir_item|
    dir_item.ljust(max_name_length + 1)
  end
end

def generate_rows(dir_items, row_count)
  rows = Array.new(row_count) { [] }

  dir_items.each_with_index do |dir_item, index|
    rows[index % row_count].push(dir_item)
  end

  rows
end

main
