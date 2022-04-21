#!/usr/bin/env ruby

# frozen_string_literal: true

require 'etc'
require 'optparse'

COLUMN_COUNT = 3

FILE_TYPE = {
  '1' => 'p',
  '2' => 'c',
  '4' => 'd',
  '6' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

FILE_PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  is_option_all = false
  is_reverse = false
  is_detail = false

  opt = OptionParser.new
  opt.on('-a') { is_option_all = true }
  opt.on('-r') { is_reverse = true }
  opt.on('-l') { is_detail = true }
  opt.parse!(ARGV)

  file_names = is_option_all ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_file_names = is_reverse ? file_names.reverse : file_names

  if is_detail
    show_file_details(sorted_file_names)
  else
    show_file_names(sorted_file_names)
  end
end

def show_file_details(file_name)
  extracted_details = extract_detail(generate_details, file_name)
  formed_details = form_details(extracted_details)

  puts "total #{formed_details['blocks'].sum}"

  formed_details['file_names'].each_with_index do |_, index|
    show_item = []
    show_item.push(formed_details['symbolic_modes'][index])
    show_item.push(formed_details['hard_link_strings'][index])
    show_item.push(formed_details['user_names'][index])
    show_item.push(formed_details['group_names'][index])
    show_item.push(formed_details['size_strings'][index])
    show_item.push(formed_details['updated_times'][index])
    show_item.push(formed_details['file_names'][index])

    puts show_item.join(' ')
  end
end

def generate_details
  {
    'blocks' => [],
    'symbolic_modes' => [],
    'hard_link_strings' => [],
    'user_names' => [],
    'group_names' => [],
    'size_strings' => [],
    'updated_times' => [],
    'file_names' => []
  }
end

def extract_detail(details, file_names)
  file_names.map do |file_name|
    file = File::Stat.new("./#{file_name}")

    details['blocks'].push(file.blocks)
    details['symbolic_modes'].push(file_symbolic_mode(file))
    details['hard_link_strings'].push(file.nlink.to_s)
    details['user_names'].push(file_user_name(file))
    details['group_names'].push(file_group_name(file))
    details['size_strings'].push(file.size.to_s)
    details['updated_times'].push(format_file_time(file))
    details['file_names'].push(file_name)
  end

  details
end

def form_details(details)
  max_hard_link_string_length = details['hard_link_strings'].max_by(&:length).length
  details['hard_link_strings'] = rjust_items(max_hard_link_string_length, details['hard_link_strings'])

  max_user_name_length = details['user_names'].max_by(&:length).length
  details['user_names'] = ljust_items(max_user_name_length, details['user_names'])

  max_group_name_length = details['group_names'].max_by(&:length).length
  details['group_names'] = ljust_items(max_group_name_length, details['group_names'])

  max_sizes_length = details['size_strings'].max_by(&:length).length
  details['size_strings'] = rjust_items(max_sizes_length, details['size_strings'])

  details
end

def show_file_names(file_names)
  max_name_length = file_names.max_by(&:length).length

  rows = generate_rows(
    ljust_items(max_name_length, file_names),
    calc_row_count(file_names.size)
  )
  rows.each { |row| puts row.join(' ') }
end

def convert_to_symbolic_type(file_octal_type)
  FILE_TYPE[file_octal_type]
end

def convert_to_symbolic_permission(file_octal_permission)
  FILE_PERMISSION[file_octal_permission]
end

def file_symbolic_mode(file)
  octal_mode = file.mode.to_s(8)

  symbolic_type = convert_to_symbolic_type(octal_mode[0..-5])
  symbolic_permissions = octal_mode[-3..].chars.map do |octal_permission|
    convert_to_symbolic_permission(octal_permission)
  end

  symbolic_type + symbolic_permissions.join('')
end

def file_user_name(file)
  Etc.getpwuid(file.uid).name
end

def file_group_name(file)
  Etc.getgrgid(file.gid).name
end

def format_file_time(file)
  file.mtime.strftime('%b %d %R')
end

def calc_row_count(dir_items_count)
  (dir_items_count / COLUMN_COUNT.to_f).ceil
end

def ljust_items(max_name_length, dir_items)
  dir_items.map do |dir_item|
    dir_item.ljust(max_name_length)
  end
end

def rjust_items(max_name_length, dir_items)
  dir_items.map do |dir_item|
    dir_item.rjust(max_name_length)
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
