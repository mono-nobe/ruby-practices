#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3

def main
  is_option_all = false

  opt = OptionParser.new
  opt.on('-a') do |has_value|
    is_option_all = true if has_value
  end
  opt.parse!(ARGV)

  dir_items = Dir.entries('.').sort

  show_items = []
  if is_option_all
    show_items.concat(dir_items)
  else
    show_items.concat(filter_hidden_dir_items(dir_items))
  end

  max_name_length = show_items.max_by(&:length).length

  rows = generate_rows(
    ljust_dir_items(max_name_length, show_items),
    calc_row_count(show_items.size)
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

def filter_hidden_dir_items(dir_items)
  dir_items.reject { |dir_item| dir_item.start_with?('.') }
end

def generate_rows(dir_items, row_count)
  rows = Array.new(row_count) { [] }

  dir_items.each_with_index do |dir_item, index|
    rows[index % row_count].push(dir_item)
  end

  rows
end

main
