require_relative '../read_file'

input = read_file('input.txt', &:to_i)

pairs = input.permutation(2)

puts "Testing #{pairs.count} pairs of numbers..."
result = pairs.find { |pair| pair.sum == 2020 }

puts "#{result} adds up to 2020"
puts "Product of result is #{result.reduce(:*)}"
