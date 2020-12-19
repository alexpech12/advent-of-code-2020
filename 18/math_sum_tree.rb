class Integer
  def evaluate(_ = nil)
    self
  end
end

class MathSum
  class << self
    def parse(sum_string, precedence = nil)
      values = []
      operations = []
      sub_string = nil
      bracket_level = 0
      sum_string.gsub(' ', '').chars.each do |char|
        # Break up any bracketed sections into sub-sums
        # Only go 1 level deep. Other sums will recurse until all are accounted for.

        if char == '('
          if bracket_level.positive?
            sub_string += char
          else
            sub_string = ''
          end
          bracket_level += 1
          next
        elsif char == ')'
          bracket_level -= 1
          if bracket_level.zero?
            values << MathSum.parse(sub_string, precedence)
          else
            sub_string += char
          end
          next
        end

        if bracket_level.positive?
          sub_string += char
          next
        end

        if %w[+ *].include? char
          operations << char.to_sym
        else
          # This should be a number
          values << char.to_i
        end
      end
      MathSum.new(values, operations, precedence)
    end
  end

  attr_reader :values, :operations, :precedence

  def initialize(values, operations, precedence = nil)
    @values = values
    @operations = operations
    @precedence = precedence
  end

  def evaluate
    local_vals, local_ops =
      if precedence.nil?
        [values, operations]
      else
        vals = [values.first.evaluate]
        operations.each_with_index do |operation, i|
          if operation == precedence
            # Combine with previous value
            vals[-1] = vals[-1].send(operation, values[i + 1].evaluate)
          else
            # Preserve this value
            vals << values[i + 1].evaluate
          end
        end

        # All precedence operators have been evaluated, so we can remove them from the list
        [vals, operations - [precedence]]
      end

    local_vals[1..-1].each_with_index
                     .reduce(local_vals.first.evaluate) do |acc, (value, i)|
      acc.send(local_ops[i], value.evaluate)
    end
  end
end