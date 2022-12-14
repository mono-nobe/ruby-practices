# frozen_string_literal: true

require_relative './equipment'

class Place
  def initialize
    @equipments = Dir.glob('*', File::FNM_DOTMATCH).map do |file_name|
      Equipment.new(file_name)
    end
  end

  def test_place
    puts '####### test_dir #######'
    puts @equipments
    @equipments.map do |equipment|
      puts equipment.size
    end
  end
end
