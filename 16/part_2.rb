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

rules = input_parsers[:rules].rules
tickets = input_parsers[:tickets].tickets
my_ticket = input_parsers[:my_ticket].tickets.first

puts "Ticket count: #{tickets.count}"

valid_tickets = TicketValidator.select_valid_tickets(tickets, rules)
puts "Valid ticket count: #{valid_tickets.count}"

# For each field, determine which rules all tickets are valid for
valid_rules_for_fields = []
(0..my_ticket.fields.count - 1).each do |field_index|
  valid_rules_for_fields << { field: field_index, rules: TicketValidator.valid_rules_for_field(valid_tickets, rules, field_index) }
end

valid_rules_for_fields.each do |valid_rules|
  puts "For field #{valid_rules[:field]}, valid rules are #{valid_rules[:rules].map(&:name)}"
end

rules_for_fields = []

until valid_rules_for_fields.empty?

  decided_rules_for_fields = valid_rules_for_fields.select { |valid_rules| valid_rules[:rules].count == 1 }

  decided_rules_for_fields.each do |rules_for_field|
    rule = rules_for_field[:rules].first
    rules_for_fields << { field: rules_for_field[:field], rule: rule }

    valid_rules_for_fields.each do |valid_rules_for_field|
      valid_rules_for_field[:rules] -= [rule]
    end
  end

  valid_rules_for_fields -= decided_rules_for_fields

  puts
  valid_rules_for_fields.each do |valid_rules|
    puts "For field #{valid_rules[:field]}, valid rules are #{valid_rules[:rules].map(&:name)}"
  end
end

puts "Final rule mapping:"
rules_for_fields.each do |rules_for_field|
  field = rules_for_field[:field]
  rule = rules_for_field[:rule].name
  puts "Field #{field} is #{rule}"
end

puts
puts "My ticket:"

my_ticket.fields.each_with_index do |field, i|
  rules_for_field = rules_for_fields.find { |rules_for_field| rules_for_field[:field] == i }

  puts "#{rules_for_field[:rule].name} = #{field}"
end

puts
puts "My departure fields:"

product = 1
my_ticket.fields.each_with_index do |field, i|
  rules_for_field = rules_for_fields.find { |rules_for_field| rules_for_field[:field] == i }
  name = rules_for_field[:rule].name
  next unless name.include? 'departure'

  puts "#{name} = #{field}"
  product *= field
end

puts "Final sum = #{product}"
