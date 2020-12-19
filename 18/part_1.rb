require_relative '../read_file.rb'
require_relative 'math_sum.rb'

results = read_file('input.txt') do |line|
  evaluate_sum(line.chomp)

end

puts "All results added = #{results.sum}"
