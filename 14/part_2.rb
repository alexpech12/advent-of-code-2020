require_relative '../read_file.rb'
require_relative 'docking_computer_v2.rb'

cpu = DockingComputerV2.new

pct = 0
read_file('input.txt') do |line|
  line = line.chomp
  puts "#{pct.to_s.rjust(4, '0')}: #{line}"
  if line[0..2] == 'mem'
    addr = line.split(']').first.split('[').last.to_i
    val = line.split(' ').last.to_i
    cpu.mem_write(addr, val)
  elsif line[0..3] == 'mask'
    mask = line.split(' ').last
    cpu.update_mask(mask)
  else
    raise 'Invalid Instruction!'
  end
  pct += 1
end

puts 'Computation complete!'

memory_sum = cpu.memory.values.sum
puts "The sum of values stored in memory is #{memory_sum}"
