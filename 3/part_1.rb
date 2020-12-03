require_relative '../read_file'

toboggan_x = -3
result = read_file('input.txt') do |line|
  toboggan_x += 3
  line[toboggan_x % line.chomp.length] == '#'
end.count(true)

puts "Hit #{result} trees!"