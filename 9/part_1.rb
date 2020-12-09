require_relative '../read_file.rb'
require_relative 'xmas_decoder.rb'

PREAMBLE_SIZE = 25

decoder = XmasDecoder.new(PREAMBLE_SIZE)

read_file('input.txt') do |line|
  val = line.chomp.to_i
  if decoder.next_valid? val
    decoder << val
  else
    puts "#{val} is not valid"
    break
  end
end
