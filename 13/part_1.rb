require_relative '../read_file.rb'

def parse_bus_ids(str)
  str.split(',').select { |x| x != 'x' }.map(&:to_i)
end

timestamp = nil
bus_ids = nil

read_file('input.txt') do |line|
  if timestamp.nil?
    timestamp = line.chomp.to_i
  else
    bus_ids = parse_bus_ids(line.chomp)
  end
end

wait_times = bus_ids.reduce({}) do |acc, id|
  acc[id] = id - timestamp % id
  acc
end

min_wait_time = wait_times.values.min
min_wait_time_bus_id = wait_times.select { |_, v| v == min_wait_time }.keys.first


puts "Min wait time is #{min_wait_time} minutes for bus #{min_wait_time_bus_id}."
puts "Final result is #{min_wait_time * min_wait_time_bus_id}"