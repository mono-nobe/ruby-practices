# frozen_string_literal: true

require 'etc'

class Equipment
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

  attr_reader :name

  def initialize(name)
    @name = name
    @file = File::Stat.new("./#{@name}")
  end

  def blocks
    @file.blocks
  end

  def hard_link
    @file.nlink
  end

  def size
    @file.size
  end

  def user_name
    Etc.getpwuid(@file.uid).name
  end

  def group_name
    Etc.getgrgid(@file.gid).name
  end

  def updated_time
    @file.mtime.strftime('%m %d %R')
  end

  def symbolic_mode
    octal_mode = @file.mode.to_s(8)
    symbolic_type = FILE_TYPE[octal_mode[0..-5]]
    symbolic_permissions = octal_mode[-3..].chars.map do |octal_permission|
      FILE_PERMISSION[octal_permission]
    end

    symbolic_type + symbolic_permissions.join
  end

  def format_detail(equipment, hard_link_length, user_name_length, group_name_length, size_length)
    symbolic_mode = equipment.symbolic_mode
    hard_link = equipment.hard_link.to_s.rjust(hard_link_length)
    user_name = equipment.user_name.ljust(user_name_length)
    group_name = equipment.group_name.ljust(group_name_length)
    size = equipment.size.to_s.rjust(size_length)
    updated_time = equipment.updated_time
    name = equipment.name

    "#{symbolic_mode}  #{hard_link} #{user_name}  #{group_name}  #{size} #{updated_time} #{name}"
  end
end