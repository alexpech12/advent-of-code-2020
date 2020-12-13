require_relative '../read_file.rb'
require_relative 'vector.rb'
require_relative 'ship.rb'
require_relative 'navigation.rb'

ship = Ship.new
navigator = Navigation.new(ship)

read_file('input.txt') do |line|
  navigator.parse_instruction(line.chomp)
end

navigator.execute_instructions!

puts "Final location is #{ship.location}"
puts "Manhattan distance = #{ship.location.map(&:abs).sum}"
