class Array
  def combine(other)
    raise ArgumentError unless count == other.count

    map.with_index { |n, i| n + other[i] }
  end

  def to_range
    raise RuntimeError unless count == 2

    (self[0]..self[1])
  end
end
