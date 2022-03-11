#!/usr/bin/env ruby

# frozen_string_literal: true

COLUMN_COUNT = 3

def calc_row_count(dir_items_count)
  (dir_items_count / COLUMN_COUNT.to_f).ceil
end

def ljust_dir_items(dir_items)
  max_length_of_dir_item_name = dir_items.max_by(&:length).length + 1
  dir_items.map do |dir_item|
    dir_item.ljust(max_length_of_dir_item_name)
  end
end

def remove_hidden_dir_items(dir_items)
  dir_items.reject { |dir_item| dir_item.match?(/^\./) }
end

def generate_rows(dir_items, row_count)
  rows = []
  row_count.times { rows.push([]) }

  row_index = 0
  dir_items.each do |dir_item|
    rows[row_index].push(dir_item)
    row_index == row_count - 1 ? row_index = 0 : row_index += 1
  end

  rows
end

dir_items = Dir.entries('.').sort
ljusted_dir_items = ljust_dir_items(dir_items)
removed_hidden_dir_items = remove_hidden_dir_items(ljusted_dir_items)

rows = generate_rows(
  removed_hidden_dir_items,
  calc_row_count(removed_hidden_dir_items.size)
)

rows.each { |row| puts row.join }
