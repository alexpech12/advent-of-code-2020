input = [0, 14, 6, 20, 1, 4]

spoken_numbers = input.dup

turn_counter = spoken_numbers.count

spoken_number_map = {}

# Initialize map with input numbers
spoken_numbers[0..-2].each_with_index { |n, i| spoken_number_map[n] = i + 1 }

TURN_COUNT = 30_000_000

until turn_counter == TURN_COUNT
  last_spoken_number = spoken_numbers.last

  # Add time since last time spoken, or 0
  spoken_numbers << turn_counter - (spoken_number_map[last_spoken_number] || turn_counter)

  # Update map
  spoken_number_map[last_spoken_number] = turn_counter

  turn_counter += 1
end

puts spoken_numbers.last
