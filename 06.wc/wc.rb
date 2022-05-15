#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SINGLE_FILE_COUNT = 2

def main
  is_line = false
  opt = OptionParser.new
  opt.on('-l') { is_line = true }
  opt.parse!(ARGV)

  if !ARGV.empty?
    show_file_details(is_line)
  else
    show_stdin_details(is_line)
  end
end

def show_file_details(is_line)
  file_details = calc_file_details
  return if file_details.size.zero?

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

  print_file_details(file_details, max_detail_length, is_line)
end

def print_file_details(file_details, max_detail_length, is_line)
  details = file_details.size == SINGLE_FILE_COUNT ? file_details.slice(0..0) : file_details

  details.map do |detail|
    print detail[:line_count].to_s.rjust(max_detail_length[:line_count])
    unless is_line
      print " #{detail[:word_count].to_s.rjust(max_detail_length[:word_count])}"
      print " #{detail[:size].to_s.rjust(max_detail_length[:size])}"
    end
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
    if Dir.glob(file_name).size.zero?
      puts "wc: #{file_name}: No such file or directory"
      next
    end
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
  end.compact
end

def show_stdin_details(is_line)
  strings = $stdin.readlines

  word_count = strings.map do |string|
    string.split(' ').size
  end.sum

  details = {
    row: strings.size,
    word_count: word_count,
    byte: strings.join.bytesize
  }

  print_stdin_details(details, is_line)
end

def print_stdin_details(detail, is_line)
  if is_line
    puts detail[:row]
  else
    puts "#{detail[:row]} #{detail[:word_count]} #{detail[:byte]}"
  end
end

main
