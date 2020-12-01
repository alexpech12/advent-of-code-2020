require_relative '../read_file'

def expense_report(number = 2)
  input = read_file('input.txt', &:to_i)

  result = input.combination(number).find { |group| group.sum == 2020 }

  puts "#{result} adds up to 2020"
  puts "Product of result is #{result.reduce(:*)}"
end
