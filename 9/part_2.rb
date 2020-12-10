require_relative '../read_file.rb'
require_relative 'xmas_decoder.rb'

PREAMBLE_SIZE = 25

def get_invalid_number(input_array)
  decoder = XmasDecoder.new(PREAMBLE_SIZE)
  input_array.each do |val|
    if decoder.next_valid? val
      decoder << val
    else
      return val
    end
  end
end

def find_contiguous_for_sum(input_array, sum)
  range = (0..0)
  until range.end >= input_array.size
    range_values = input_array[range]
    range_sum = range_values.sum
    if range_sum > sum
      range = ((range.begin + 1)..(range.begin + 1))
    elsif range_sum == sum
      return range_values
    else
      range = (range.begin..(range.end + 1))
    end
  end
end

input_array = read_file('input.txt') { |line| line.chomp.to_i }
puts 'Input loaded'

invalid_number = get_invalid_number(input_array)
puts "Invalid number is #{invalid_number}"

sum_array = find_contiguous_for_sum(input_array, invalid_number)
puts "Continguous numbers adding to #{invalid_number} are #{sum_array}"

puts "The encryption weakness is #{sum_array.minmax.join(' + ')} = #{sum_array.minmax.sum}"