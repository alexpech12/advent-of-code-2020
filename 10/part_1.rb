require_relative '../read_file.rb'

adapters = read_file('input.txt') do |line|
  line.chomp.to_i
end.sort
puts adapters

# We add one to each because of the 0-1 at the start, and the +3 into our device
num_1_jolt_differences = adapters.each_cons(2).count { |pair| pair[1] - pair[0] == 1 } + 1
num_3_jolt_differences = adapters.each_cons(2).count { |pair| pair[1] - pair[0] == 3 } + 1

puts "#{num_1_jolt_differences} 1-jolt differences"
puts "#{num_3_jolt_differences} 3-jolt differences"

puts "Result = #{num_1_jolt_differences * num_3_jolt_differences}"