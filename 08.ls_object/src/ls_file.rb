# frozen_string_literal: true

require 'etc'

class LsFile
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

  attr_reader :name,
              :blocks,
              :hard_link,
              :size,
              :user_name,
              :group_name,
              :updated_time,
              :symbolic_mode

  def initialize(name)
    @name = name

    file = File::Stat.new("./#{@name}")
    @blocks = file.blocks
    @hard_link = file.nlink
    @size = file.size
    @user_name = Etc.getpwuid(file.uid).name
    @group_name = Etc.getgrgid(file.gid).name
    @updated_time = file.mtime
    @symbolic_mode = format_symbolic_mode(file)
  end

  private

  def format_symbolic_mode(file)
    octal_mode = file.mode.to_s(8)
    symbolic_type = FILE_TYPE[octal_mode[0..-5]]
    symbolic_permissions = octal_mode[-3..].chars.map do |octal_permission|
      FILE_PERMISSION[octal_permission]
    end

    symbolic_type + symbolic_permissions.join
  end
end
