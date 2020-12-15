require_relative '../read_file.rb'
require_relative 'docking_computer.rb'

cpu = DockingComputer.new

read_file('input.txt') do |line|
  line = line.chomp
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
end

puts 'Computation complete!'

memory_sum = cpu.memory.values.sum
puts "The sum of values stored in memory is #{memory_sum}"