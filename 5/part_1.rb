require_relative '../read_file.rb'
require_relative 'boarding_pass.rb'

boarding_passes = read_file('input.txt') do |line|
  BoardingPass.new(line.chomp)
end

max = boarding_passes.map(&:seat_number).max

puts "The highest seat number is #{max}"