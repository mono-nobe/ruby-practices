#!/usr/bin/env ruby

# frozen_string_literal: true

COLUMN_COUNT = 3

def main
  dir_items = Dir.entries('.').sort
  removed_hidden_dir_items = remove_hidden_dir_items(dir_items)
  max_name_length = removed_hidden_dir_items.max_by(&:length).length

  rows = generate_rows(
    ljust_dir_items(max_name_length, removed_hidden_dir_items),
    calc_row_count(removed_hidden_dir_items.size)
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

def remove_hidden_dir_items(dir_items)
  dir_items.reject { |dir_item| dir_item.match?(/^\./) }
end

def generate_rows(dir_items, row_count)
  rows = Array.new(row_count) { [] }

  row_index = 0
  dir_items.each do |dir_item|
    rows[row_index].push(dir_item)
    if row_index == row_count - 1
      row_index = 0
    else
      row_index += 1
    end
  end

  rows
end

main
