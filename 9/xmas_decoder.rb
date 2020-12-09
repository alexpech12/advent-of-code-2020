class XmasDecoder
  attr_reader :max_size

  def initialize(max_size)
    @max_size = max_size
    @buffer = []
  end

  def << (new_item)
    buffer << new_item
    truncate
  end

  def values
    buffer
  end

  def full?
    buffer.size >= max_size
  end

  def next_valid? next_value
    return true unless full?

    buffer.combination(2).any? { |pair| pair.sum == next_value }
  end

  private

  attr_reader :buffer

  def truncate
    @buffer = buffer[-max_size..-1] if full?
  end
end
