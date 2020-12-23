require_relative '../read_file.rb'
require_relative 'rule.rb'

rule_map = {}
test_strings = []

state = :rules
read_file('test_input_2_edited.txt') do |line|
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

puts "All matching strings for rule 42:"
# puts rule_map['42'].all_matching_strings.to_s

# 20 -> 54 -> 89
puts rule_map['1'].all_matching_strings.to_s
puts
puts rule_map['14'].all_matching_strings.to_s
puts
puts rule_map['21'].all_matching_strings.to_s
puts
puts rule_map['26'].all_matching_strings.to_s
return
# puts "Sub rules for rule 8:"
# sub_rules = ['8']
# until sub_rules.empty?
#   sub_rules.dup.each do |rule|
#     sub_rules -= rule
#     puts "#{rule_map[rule.sub_rule_strings_1]} | #{rule_map[rule.sub_rule_strings_2]}"
#   end
# end


# 8: 42 | 42 8
# 11: 42 31 | 42 11 31








return

puts 'Running tests...'

match_count = test_strings.count do |test|
  # puts "Testing string #{test}..."
  result = rule_map['0'].match(test)
  final_result = result[0] && result[1].empty?
  # puts "Result is #{final_result}"
  # puts
  puts "#{test} - #{final_result ? 'Match!' : 'X'}"
  final_result
end

puts "Match count for rule 0 = #{match_count}"
