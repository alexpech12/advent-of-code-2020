require_relative '../read_file'

def go_tobogganing(slope_x, slope_y)
  toboggan_x = -slope_x
  toboggan_y = -1
  read_file('input.txt') do |line|
    toboggan_y += 1
    next unless (toboggan_y % slope_y).zero?

    toboggan_x += slope_x

    line[toboggan_x % line.chomp.length] == '#'
  end.count(true)
end

slopes = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]
results = slopes.map do |slope|
  go_tobogganing(*slope).tap { |result| puts "Hit #{result} trees on slope #{slope}!" }
end

puts "If we multiply the results together, we get #{results.reduce(&:*)}"
