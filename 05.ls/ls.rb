#!/usr/bin/env ruby

# frozen_string_literal: true

COLUMN_COUNT = 3

def main
  dir_items = Dir.entries('.').sort
  filtered_dir_items = filter_hidden_dir_items(dir_items)
  max_name_length = filtered_dir_items.max_by(&:length).length

  rows = generate_rows(
    ljust_dir_items(max_name_length, filtered_dir_items),
    calc_row_count(filtered_dir_items.size)
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
  dir_items.reject { |dir_item| dir_item.start_with?(/^\./) }
end

def generate_rows(dir_items, row_count)
  rows = Array.new(row_count) { [] }

  dir_items.each_with_index do |dir_item, index|
    rows[index % row_count].push(dir_item)
  end

  rows
end

main
