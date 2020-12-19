def evaluate_sum(sum_string)
  result_stack = [nil]
  operation_stack = []
  # puts "\nProcessing sum #{sum_string.chomp}..."
  sum_string = sum_string.chars - [' ']
  sum_string.each_with_index do |char, i|
    # puts "\n#{sum_string[0..i].join(' ')}"
    if char == '('
      # Start nested expression
      result_stack << nil
    elsif char == ')'
      # Close nested expression
      result = result_stack.pop
      result_stack[-1] =
        if result_stack.last.nil?
          result
        else
          result_stack.last.send(operation_stack.pop, result)
        end
    elsif char == '+'
      # Get ready for addition
      operation_stack << :+
    elsif char == '*'
      # Get ready for multiplication
      operation_stack << :*
    else
      # Getting a number
      result_stack[-1] =
        if result_stack.last.nil?
          # This is the first number
          char.to_i
        else
          # Apply the next action to the result with this number
          result_stack.last.send(operation_stack.pop, char.to_i)
        end
    end
    # puts "Stacks: #{result_stack}, #{operation_stack}"
  end
  result_stack[0]
end