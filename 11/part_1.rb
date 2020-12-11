require_relative '../read_file.rb'
require_relative 'seating.rb'

grid = SeatingGrid.new
new_grid = nil

read_file('input.txt') do |line|
  grid.parse_row(line.chomp)
end

loop do
  # Generate the grid at the next step
  new_grid = grid.people_do_things
  # Check our end condition
  break if new_grid.diff_count(grid).zero?

  grid = new_grid
end

puts "Occupied seats: #{new_grid.occupied_seats.count}"
