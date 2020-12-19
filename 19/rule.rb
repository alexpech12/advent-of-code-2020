class BasicRule
  attr_reader :char

  def initialize(char)
    @char = char
  end

  def link_rules(_); end

  def match(str)
    return false unless str[0] == char

    [true, str[1..-1]]
  end
end

class Rule
  attr_reader :sub_rule_strings_1, :sub_rule_strings_2, :sub_rules_1, :sub_rules_2

  def initialize(sub_rule_strings_1, sub_rule_strings_2 = nil)
    @sub_rule_strings_1 = sub_rule_strings_1
    @sub_rule_strings_2 = sub_rule_strings_2
  end

  def link_rules(rule_map)
    @sub_rules_1 = sub_rule_strings_1.map { |rule| rule_map[rule] }
    @sub_rules_2 = sub_rule_strings_2.map { |rule| rule_map[rule] } unless sub_rule_strings_2.nil?
  end

  def match(str)
    remaining_str = str.dup
    matches = sub_rules_1.all? do |rule|
      result, remaining_str = rule.match(remaining_str)
      result
    end

    return [matches, remaining_str] if matches || sub_rules_2.nil?

    remaining_str = str.dup
    matches = sub_rules_2.all? do |rule|
      result, remaining_str = rule.match(remaining_str)
      result
    end

    [matches, remaining_str]
  end
end
