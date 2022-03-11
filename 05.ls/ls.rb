#!/usr/bin/env ruby

# frozen_string_literal: true

NUM_OF_COLUMNS = 3

def calc_num_of_row(num_of_dir_items)
  (num_of_dir_items / NUM_OF_COLUMNS.to_f).ceil
end

def ljust_dir_items(dir_items)
  max_length_of_dir_item_name = dir_items.max_by(&:length).length + 1
  dir_items.map do |dir_item|
    dir_item.ljust(max_length_of_dir_item_name)
  end
end

def remove_hidden_dir_items(dir_items)
  dir_items.delete_if { |dir_item| dir_item.match?(/^\./) }
end

def generate_rows(dir_items, num_of_row)
  rows = []
  num_of_row.times { rows.push([]) }

  row_index = 0
  dir_items.each do |dir_item|
    rows[row_index].push(dir_item)
    row_index == num_of_row - 1 ? row_index = 0 : row_index += 1
  end

  rows
end

dir_items = Dir.entries('.').sort
ljusted_dir_items = ljust_dir_items(dir_items)

rows = generate_rows(
  remove_hidden_dir_items(ljusted_dir_items),
  calc_num_of_row(ljusted_dir_items.size)
)

rows.each { |row| puts row.join }
