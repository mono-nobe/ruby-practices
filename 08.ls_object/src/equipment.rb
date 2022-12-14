# frozen_string_literal: true

class Equipment
  def initialize(file_name)
    @file = File::Stat.new("./#{file_name}")
  end

  def size
    @file.size
  end
end
