require_relative '../read_file.rb'

# Abusing ruby extensions on the Array class
class Array
  def differential
    each_cons(2).map { |x, y| y - x }
  end

  def select_triplet_indices
    each_cons(3).select { |triple| triple.differential.sum > 3 }
                .map { |triple| find_index(triple[1]) }
  end
end

adapters = read_file('input.txt') do |line|
  line.chomp.to_i
end.sort

# This is the naive brute force method. We can use it for small sequences.
def brute_force_combinations(array)
  results = [[array.first]]

  until results.all? { |result| result.last == array.last }
    new_results = []
    results.each do |result|
      val = result.last
      next if val == array.last # This sequence is done

      i = array.find_index(val)

      valid_next_values = array[(i + 1)..[i + 3, array.last].min].select { |v| v <= val + 3 }

      # Always add the first one to the existing sequences
      result << valid_next_values.first

      # If we have additional values, create new duplicate sequences for them,
      # changing the final value to create the branch.
      new_results << result.dup.tap { |r| r[-1] = valid_next_values[1] } if valid_next_values.count >= 2
      new_results << result.dup.tap { |r| r[-1] = valid_next_values[2] } if valid_next_values.count == 3
    end
    results += new_results
  end
  results
end

# Add the first and last adapter values to our list
adapters = [0] + adapters + [adapters.last + 3]

# Anywhere our sequence has two gaps next to each other greater than 3, means that number can't be skipped.
# The number has to be in every sequence. We can take advantage of this and split up our sequence at those points.
split_indices = adapters.select_triplet_indices

# Make sure we have the first and last index values in our list
split_indices = [0] + split_indices unless split_indices.first.zero?
split_indices += [adapters.last] unless split_indices.last == adapters.last

# Split our adapter list up into sub-sequences to be calculated separately
sub_adapters = split_indices.each_cons(2).map do |pair|
  adapters[pair[0]..pair[1]]
end

# Brute force each sub-sequence
results = sub_adapters.map do |a|
  brute_force_combinations(a)
end

results.each_with_index do |r, i|
  puts "#{i}: (#{r.count}) - #{r}"
end

# By counting the number of combinations for each sub-sequence and multiplying them all together,
# we can calculate our final result.
puts "Final result = #{results.map(&:count).reduce(&:*)}"
