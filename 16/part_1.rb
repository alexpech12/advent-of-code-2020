require_relative '../read_file.rb'
require_relative 'rule_parser.rb'
require_relative 'ticket_parser.rb'
require_relative 'ticket_validator.rb'

input_parsers = {
  rules: RuleParser.new,
  my_ticket: TicketParser.new,
  tickets: TicketParser.new
}

read_mode = :rules
read_file('input.txt') do |line|
  line = line.chomp
  next if line.empty?

  # Set input-reading mode
  if line == 'your ticket:'
    read_mode = :my_ticket
    next
  elsif line == 'nearby tickets:'
    read_mode = :tickets
    next
  end

  # Actually read the input
  input_parsers[read_mode].parse(line)
end

ticket_scanning_errors = TicketValidator.find_all_invalid_values(
  input_parsers[:tickets].tickets,
  input_parsers[:rules].rules
)

puts "Ticket scanning errors: #{ticket_scanning_errors}"
puts "Error rate is: #{ticket_scanning_errors.sum}"
