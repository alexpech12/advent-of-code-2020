input = [0, 14, 6, 20, 1, 4]

spoken_numbers = input.dup

until spoken_numbers.count == 2020
  last_number = spoken_numbers.last
  if spoken_numbers[0..-2].any? last_number
    turn_last_spoken = spoken_numbers[0..-2].rindex(last_number) + 1
    spoken_numbers << spoken_numbers.count - turn_last_spoken
  else
    spoken_numbers << 0
  end
end

puts spoken_numbers.last
