require_relative '../read_file.rb'
require_relative 'boarding_pass.rb'

boarding_passes = read_file('input.txt') do |line|
  BoardingPass.new(line.chomp)
end

# For this part, we need to find the missing seat number.
# Let's sort by seat number, then do a search to find the gap.
#
# Note on the use of each_cons:
#   each_cons enumerates consecutive groups, so,
#   [1,2,3].each_cons(2) => [[1,2], [2,3]]
#
# This allows us to compare numbers side by side and see if they're
# consecutive or not.

# This will be our test for consecutive pairs
nonconsecutive = ->((x, y)) { x + 1 != y }

missing_seat_number =
  boarding_passes.map(&:seat_number)
                 .sort
                 .each_cons(2)
                 .find(&nonconsecutive)
                 .first + 1

puts "My seat number is #{missing_seat_number}!"
