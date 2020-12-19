require_relative '../read_file.rb'
require_relative 'rule.rb'

rule_map = {}
test_strings = []

state = :rules
read_file('input.txt') do |line|
  line = line.chomp

  case state
  when :rules
    if line.empty?
      state = :tests
      next
    end

    rule_num, rule_str = line.split(':')
    if rule_str.include? '"'
      rule_map[rule_num] = BasicRule.new(
        rule_str.strip.gsub('"', '')
      )
    else
      rule_map[rule_num] = Rule.new(
        *rule_str.split('|').map(&:strip).map(&:split)
      )
    end
  when :tests
    test_strings << line
  end
end

puts 'Creating graph...'
rule_map.each do |_, rule|
  rule.link_rules(rule_map)
end

puts 'Running tests...'

match_count = test_strings.count do |test|
  puts "Testing string #{test}..."
  result = rule_map['0'].match(test)
  final_result = result[0] && result[1].empty?
  puts "Result is #{final_result}"
  puts
  final_result
end

puts "Match count for rule 0 = #{match_count}"
