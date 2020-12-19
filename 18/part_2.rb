require_relative '../read_file.rb'
require_relative 'math_sum_tree.rb'

results = read_file('input.txt') do |line|
  MathSum.parse(line.chomp, :+).evaluate
end

puts "All results added = #{results.sum}"
