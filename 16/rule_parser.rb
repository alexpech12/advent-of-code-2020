class Rule
  attr_reader :name, :ranges

  def initialize(name:, ranges:)
    @name = name
    @ranges = ranges
  end

  def valid?(value)
    ranges.any? { |range| range.cover?(value) }
  end
end

class RuleParser
  attr_reader :rules

  def initialize
    @rules = []
  end

  def parse(input)
    name, range_part = input.split(': ')
    ranges = range_part.split(' or ').map do |range_str|
      min, max = range_str.split('-').map(&:to_i)
      (min..max)
    end
    rules << Rule.new(name: name, ranges: ranges)
  end
end
