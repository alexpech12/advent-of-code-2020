require_relative '../read_file.rb'
require 'set'

group_count_sum = read_file_groups('input.txt') do |group|
  group.split('').to_set.length
end.sum

puts "Sum of all groups is #{group_count_sum}"
