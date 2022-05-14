#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SINGLE_FILE_COUNT = 2

def main
  is_files = !ARGV.empty?

  if is_files
    show_file_details
  else
    puts 'hoge'
  end
end

def show_file_details
  file_details = calc_file_details
  file_details.push(
    {
      line_count: calc_total_value(file_details, :line_count),
      word_count: calc_total_value(file_details, :word_count),
      size: calc_total_value(file_details, :size),
      file_name: 'total'
    }
  )

  max_detail_length = {
    line_count: calc_max_value_length(file_details, :line_count),
    word_count: calc_max_value_length(file_details, :word_count),
    size: calc_max_value_length(file_details, :size),
    file_name: calc_max_value_length(file_details, :file_name)
  }

  print_file_details(file_details, max_detail_length)
end

def print_file_details(file_details, max_detail_length)
  details = file_details.size == SINGLE_FILE_COUNT ? file_details.slice(0..0) : file_details

  details.map do |detail|
    print " #{detail[:line_count].to_s.rjust(max_detail_length[:line_count])}"
    print "  #{detail[:word_count].to_s.rjust(max_detail_length[:word_count])}"
    print " #{detail[:size].to_s.rjust(max_detail_length[:size])}"
    puts " #{detail[:file_name].to_s.ljust(max_detail_length[:file_name])}"
  end
end

def calc_max_value_length(hashes, key)
  hashes.map do |hash|
    hash[key].to_s
  end.max_by(&:length).length
end

def calc_total_value(details, key)
  details.map do |detail|
    detail[key]
  end.sum
end

def calc_file_details
  ARGV.map do |file_name|
    file = File.open(file_name)

    words = []
    line_count = 0
    file.each_line do |line|
      words.push(line.split(' ').size)
      line_count += 1
    end

    {
      line_count: line_count,
      word_count: words.sum,
      size: file.size,
      file_name: file_name
    }
  end
end

main
