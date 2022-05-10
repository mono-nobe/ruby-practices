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
  is_all = false
  is_reverse = false
  is_detail = false

  opt = OptionParser.new
  opt.on('-a') { is_all = true }
  opt.on('-r') { is_reverse = true }
  opt.on('-l') { is_detail = true }
  opt.parse!(ARGV)

  file_names = is_all ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_file_names = is_reverse ? file_names.reverse : file_names

  if is_detail
    show_file_details(sorted_file_names)
  else
    show_file_names(sorted_file_names)
  end
end

def show_file_details(file_names)
  details = extract_details(file_names)
  total_blocks = details.sum { |detail| detail[:blocks] }
  max_hard_link_length = calc_max_string_length(details, :hard_link)
  max_user_name_length = calc_max_string_length(details, :user_name)
  max_group_name_length = calc_max_string_length(details, :group_name)
  max_size_length = calc_max_string_length(details, :size)

  puts "total #{total_blocks}"
  details.map do |detail|
    hard_link = detail[:hard_link].to_s.rjust(max_hard_link_length)
    user_name = detail[:user_name].ljust(max_user_name_length)
    group_name = detail[:group_name].ljust(max_group_name_length)
    size = detail[:size].to_s.rjust(max_size_length)

    puts "#{detail[:symbolic_mode]} #{hard_link} #{user_name} #{group_name} #{size} #{detail[:updated_time]} #{detail[:file_name]}"
  end
end

def calc_max_string_length(details, key)
  details.map do |detail|
    detail[key].to_s
  end.max_by(&:length).length
end

def extract_details(file_names)
  file_names.map do |file_name|
    file = File::Stat.new("./#{file_name}")

    {
      blocks: file.blocks,
      symbolic_mode: file_symbolic_mode(file),
      hard_link: file.nlink,
      user_name: file_user_name(file),
      group_name: file_group_name(file),
      size: file.size,
      updated_time: format_file_time(file),
      file_name: file_name
    }
  end
end

def file_symbolic_mode(file)
  octal_mode = file.mode.to_s(8)

  symbolic_type = FILE_TYPE[octal_mode[0..-5]]
  symbolic_permissions = octal_mode[-3..].chars.map do |octal_permission|
    FILE_PERMISSION[octal_permission]
  end

  symbolic_type + symbolic_permissions.join
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

def show_file_names(file_names)
  max_name_length = file_names.max_by(&:length).length

  rows = generate_rows(
    ljust_items(max_name_length, file_names),
    calc_row_count(file_names.size)
  )
  rows.each { |row| puts row.join(' ') }
end

def generate_rows(dir_items, row_count)
  rows = Array.new(row_count) { [] }

  dir_items.each_with_index do |dir_item, index|
    rows[index % row_count].push(dir_item)
  end

  rows
end

def calc_row_count(dir_items_count)
  (dir_items_count / COLUMN_COUNT.to_f).ceil
end

def ljust_items(max_name_length, dir_items)
  dir_items.map do |dir_item|
    dir_item.ljust(max_name_length)
  end
end

main
