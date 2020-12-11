require_relative '../read_file.rb'
require_relative 'seating.rb'

def test_1
  grid = SeatingGrid.new
  read_file('test_1.txt') do |line|
    grid.parse_row(line.chomp)
  end

  puts grid.visible_seats(3, 4).map(&:type).to_s
end

def test_2
  grid = SeatingGrid.new
  read_file('test_2.txt') do |line|
    grid.parse_row(line.chomp)
  end
  puts "Seat left #{grid.first_seat_in_direction(1,1,-1,0)}"
  puts "Seat top #{grid.first_seat_in_direction(1,1,0,-1)}"
  puts "Seat right #{grid.first_seat_in_direction(1,1,1,0)}"
  puts "Seat bottom #{grid.first_seat_in_direction(1,1,0,1)}"
  puts grid.visible_seats(1, 1).map(&:type).to_s
end

test_1
test_2