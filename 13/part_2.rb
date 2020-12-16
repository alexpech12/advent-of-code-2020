require_relative '../read_file.rb'
require_relative 'math.rb'

def parse_bus_ids(str)
  # Map by bus_id => expected remainder
  # str.split(',').each_with_index.reduce({}) do |acc, (id, index)|
  #   unless id == 'x'
  #     id = id.to_i
  #     remainder = id - index
  #     remainder = remainder % id
  #     acc[id] = remainder
  #   end
  #   acc
  # end
  str.split(',').each_with_index.reduce([]) do |acc, (id, index)|
    unless id == 'x'
      id = id.to_i
      remainder = id - index
      remainder = remainder % id
      acc << [id, remainder]
    end
    acc
  end
end

def test_timestamp(timestamp, id, remainder)
  (timestamp % id) == remainder
end

def print_id_table(ids, range)
  print ''.rjust(10)
  ids.each { |id| print id.to_s.rjust(5) }
  puts
  range.each do |i|
    print i.to_s.rjust(10)
    ids.each do |id|
      print (!id.zero? && (i % id).zero? ? 'D' : '.').rjust(5)
    end
    puts
  end
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

# Only good for small numbers
def brute_force_method(bus_ids)
  (0..).each do |t|
    have_result = bus_ids.all? do |(id, remainder)|
      test_timestamp(t, id, remainder)
    end
    if have_result
      puts "Match at timestamp #{t}"
      break
    end
  end
end

def chinese_remainder_method(bus_ids)

  # Chinese remainder theorem
  #
  # We need to know the remainders of an integer N, by several other integers.
  # As long as the divisors are pairwise coprime (they are), we can then find N.
  #
  # The remainders are the time offsets for each bus we require.
  # N is the timestamp we're looking for.

  # Example:
  # N % 3 = 0
  # N % 4 = 3
  # N % 5 = 4

  puts bus_ids.to_s

  used_id_product = bus_ids.first[0]
  result = bus_ids.first[1]
  m1 = nil
  m2 = nil
  last_id = nil
  bus_ids[1..-1].each do |(id, remainder)|
    last_id = [id, remainder]
    puts "Testing pair #{[id, remainder]} with last result #{[used_id_product, result]}"
    puts "Testing gcd(#{id}, #{used_id_product})"
    m1, m2 = extended_gcd(id, used_id_product)
    puts "Coefficients are #{m1}, #{m2}"
    puts "#{result} x #{m1} x #{id} + #{remainder} x #{m2} x #{used_id_product}"
    result = result * m1 * id + remainder * m2 * used_id_product
    puts "Intermediate_result is #{result}"

    used_id_product *= id
  end


  puts "Result: #{result}"

  # Get first positive multiple
  if result < 0
    neg_cnt = result.abs / used_id_product
    result += used_id_product * (neg_cnt + 1)
  elsif result > used_id_product
    pos_cnt = result.abs / used_id_product
    result += -used_id_product * (pos_cnt)
  end

  puts "Final product: #{used_id_product}"
  puts "Final result: #{result}"
end

chinese_remainder_method(bus_ids)
